import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/restaurant_local_datasource.dart';
import '../../data/repository/restaurant_repository_impl.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';
import '../widgets/featured_restaurant_card.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/restaurant_section_title.dart';
import 'restaurant_details_page.dart';

class RestaurantListingPage extends StatelessWidget {
  const RestaurantListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = RestaurantLocalDataSourceImpl();
    final repository = RestaurantRepositoryImpl(
      localDataSource: localDataSource,
    );

    return BlocProvider(
      create: (_) => RestaurantBloc(
        getRestaurants: GetRestaurantsUseCase(repository),
        toggleFavorite: ToggleRestaurantFavoriteUseCase(repository),
        reserveTable: ReserveTableUseCase(repository),
      )..add(const LoadRestaurants()),
      child: const _RestaurantListingBody(),
    );
  }
}

class _RestaurantListingBody extends StatefulWidget {
  const _RestaurantListingBody();

  @override
  State<_RestaurantListingBody> createState() => _RestaurantListingBodyState();
}

class _RestaurantListingBodyState extends State<_RestaurantListingBody> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCuisine = 'All';
  String _selectedFloor = 'All';
  bool _openOnly = false;
  String _selectedWaitTime = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(BuildContext context) {
    context.read<RestaurantBloc>().add(
      FilterRestaurants(
        cuisine: _selectedCuisine,
        floor: _selectedFloor,
        openOnly: _openOnly,
        maxWaitTime: _selectedWaitTime,
        searchQuery: _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // surface-bright
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading || state is RestaurantInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
                ),
              );
            }

            if (state is RestaurantError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64.0,
                        color: Color(0xFFBA1A1A),
                      ),
                      const SizedBox(height: 16.0),
                      Text(state.errorMessage),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () => context.read<RestaurantBloc>().add(
                          const LoadRestaurants(),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is RestaurantsLoaded) {
              final query = state.searchQuery.toLowerCase();
              final allRestaurants = state.restaurants;

              // Apply client-side filters
              final filteredRestaurants = allRestaurants.where((r) {
                final matchesQuery =
                    r.name.toLowerCase().contains(query) ||
                    r.cuisine.toLowerCase().contains(query);

                final matchesCuisine =
                    state.selectedCuisine == 'All' ||
                    r.cuisine.toLowerCase().contains(
                      state.selectedCuisine.toLowerCase(),
                    );

                final matchesFloor =
                    state.selectedFloor == 'All' ||
                    r.floorText.toLowerCase().contains(
                      state.selectedFloor.toLowerCase(),
                    );

                final matchesOpen = !state.openOnly || r.isOpen;

                bool matchesWait = true;
                if (state.maxWaitTime != 'All') {
                  final waitMin =
                      int.tryParse(
                        r.waitTimeText.replaceAll(RegExp(r'[^0-9]'), ''),
                      ) ??
                      0;
                  if (state.maxWaitTime == '10 min') {
                    matchesWait = waitMin <= 10;
                  } else if (state.maxWaitTime == '20 min') {
                    matchesWait = waitMin <= 20;
                  }
                }

                return matchesQuery &&
                    matchesCuisine &&
                    matchesFloor &&
                    matchesOpen &&
                    matchesWait;
              }).toList();

              // Separate featured
              final featuredList = filteredRestaurants
                  .where((r) => r.rating >= 4.7)
                  .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RestaurantBloc>().add(
                    const RefreshRestaurants(),
                  );
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            if (canPop) ...[
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFF1D1A25),
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFFEDE5F5,
                                  ), // surface-container-high
                                  minimumSize: const Size(40.0, 40.0),
                                  shape: const CircleBorder(),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Restaurants',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D1A25), // on-surface
                                    ),
                                  ),
                                  SizedBox(height: 1.0),
                                  Text(
                                    'Discover dining and cafés',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12.0,
                                      color: Color(
                                        0xFF4A4456,
                                      ), // on-surface-variant
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_none_outlined,
                                color: Color(0xFF6100D6),
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFEDE5F5),
                                shape: const CircleBorder(),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF6100D6),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCMP8Fhio9bpJhWr4in9tUOg-qV7MzIpjA4XnIywVe_nRYQLIuxPy0Q51m6xzIFoa5sxtZzcOoVL_ehBfJwM76PQa7H160NoQxDqCRTNvI8XzoV0jZJDSJmfSYS-OwZfHTKIfTlO-YrsFo5NmJ0mvquyQQGPcLnSh7G53HwHcx8ZU3lmYR72D2sjNJxpAQ34iRWXMELtc7NsDLjs5VVNeJxP7vmpkOziZVEW2l35R7diiDMO-njG-WYK3td1nYiEGSg_SIzjlwzag',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_outlined,
                                color: Color(0xFF7B7488),
                                size: 20.0,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => _applyFilters(context),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Search restaurants, cuisines or cafés...',
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFF7B7488),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.mic_outlined,
                                color: Color(0xFF6100D6),
                                size: 20.0,
                              ),
                              const SizedBox(width: 12.0),
                              const Icon(
                                Icons.qr_code_scanner_outlined,
                                color: Color(0xFF6100D6),
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Category filters list
                      SizedBox(
                        height: 38.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          children: [
                            // Floor dropdown chip simulator
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE5F5),
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                  color: const Color(
                                    0xFFCCC3D9,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 8.0,
                              ),
                              child: PopupMenuButton<String>(
                                initialValue: _selectedFloor,
                                onSelected: (val) {
                                  setState(() => _selectedFloor = val);
                                  _applyFilters(context);
                                },
                                itemBuilder: (_) =>
                                    ['All', 'Ground', 'Level 1', 'Level 3']
                                        .map(
                                          (f) => PopupMenuItem(
                                            value: f == 'All' ? 'All' : f,
                                            child: Text(
                                              f == 'All'
                                                  ? 'All Floors'
                                                  : '$f Floor',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedFloor == 'All'
                                          ? 'All Floors'
                                          : 'Floor: $_selectedFloor',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D1A25),
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),

                            // Cuisine Chips
                            ...[
                              'All',
                              'French',
                              'Japanese',
                              'Burgers',
                              'Cafe',
                            ].map((cuisineOpt) {
                              final isSelected =
                                  state.selectedCuisine == cuisineOpt;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(
                                    cuisineOpt == 'All'
                                        ? 'All Cuisines'
                                        : cuisineOpt,
                                  ),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    setState(
                                      () => _selectedCuisine = cuisineOpt,
                                    );
                                    _applyFilters(context);
                                  },
                                  selectedColor: const Color(0xFF6100D6),
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF4A4456),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xFF6100D6)
                                          : const Color(0xFFEDE5F5),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      // Wait Time & Open status filters
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            // Open Now switch
                            FilterChip(
                              label: const Text('Open Now'),
                              selected: state.openOnly,
                              onSelected: (val) {
                                setState(() => _openOnly = val);
                                _applyFilters(context);
                              },
                              selectedColor: const Color(
                                0xFF6100D6,
                              ).withOpacity(0.1),
                              checkmarkColor: const Color(0xFF6100D6),
                              labelStyle: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6100D6),
                              ),
                            ),
                            const SizedBox(width: 8.0),

                            // Wait Time Filter Popup
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                  color: const Color(0xFFEDE5F5),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 8.0,
                              ),
                              child: PopupMenuButton<String>(
                                initialValue: _selectedWaitTime,
                                onSelected: (val) {
                                  setState(() => _selectedWaitTime = val);
                                  _applyFilters(context);
                                },
                                itemBuilder: (_) => ['All', '10 min', '20 min']
                                    .map(
                                      (w) => PopupMenuItem(
                                        value: w,
                                        child: Text(
                                          w == 'All'
                                              ? 'Any Wait Time'
                                              : 'Under $w',
                                        ),
                                      ),
                                    )
                                    .toList(),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedWaitTime == 'All'
                                          ? 'Waiting Time'
                                          : 'Wait: ≤ $_selectedWaitTime',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A4456),
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      size: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Featured Exclusives carousel
                      if (featuredList.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantSectionTitle(
                            title: 'Trending This Week',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 280.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            clipBehavior: Clip.none,
                            itemCount: featuredList.length,
                            itemBuilder: (context, index) {
                              final item = featuredList[index];
                              return FeaturedRestaurantCard(
                                restaurant: item,
                                onTap: () =>
                                    _navigateToDetails(context, item.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // Popular list heading
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: RestaurantSectionTitle(title: 'Popular Dining'),
                      ),
                      const SizedBox(height: 12.0),

                      // Vertical List of all filtered restaurants
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: filteredRestaurants.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: Text(
                                    'No restaurants match your filters.',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF7B7488),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: filteredRestaurants.map((item) {
                                  return RestaurantCard(
                                    restaurant: item,
                                    onTap: () =>
                                        _navigateToDetails(context, item.id),
                                    onNavigate: () {},
                                    onReserve: () =>
                                        _navigateToDetails(context, item.id),
                                    onFavorite: () {
                                      context.read<RestaurantBloc>().add(
                                        ToggleFavoriteRestaurant(
                                          restaurantId: item.id,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, String restaurantId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailsPage(restaurantId: restaurantId),
      ),
    );
  }
}

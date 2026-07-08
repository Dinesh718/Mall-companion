import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/store_local_datasource.dart';
import '../../data/repository/store_repository_impl.dart';
import '../../domain/usecases/get_stores_usecase.dart';
import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../widgets/store_card.dart';
import '../widgets/store_category_chip.dart';
import '../widgets/store_logo.dart';
import '../widgets/store_section_title.dart';
import 'store_details_page.dart';

class StoreListingPage extends StatelessWidget {
  const StoreListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = StoreRepositoryImpl(
      localDataSource: StoreLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => StoreBloc(
        getStoresData: GetStoresData(repository),
        toggleFavoriteStoreUseCase: ToggleFavoriteStoreUseCase(repository),
      )..add(const LoadStores()),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // background/surface
        body: StoreListingPageBody(),
      ),
    );
  }
}

class StoreListingPageBody extends StatefulWidget {
  const StoreListingPageBody({super.key});

  @override
  State<StoreListingPageBody> createState() => _StoreListingPageBodyState();
}

class _StoreListingPageBodyState extends State<StoreListingPageBody> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 20.0) {
      if (!_isHeaderCollapsed) {
        setState(() {
          _isHeaderCollapsed = true;
        });
      }
    } else {
      if (_isHeaderCollapsed) {
        setState(() {
          _isHeaderCollapsed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state is StoreInitial || state is StoreLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is StoreError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64.0, color: Color(0xFFBA1A1A)),
                  const SizedBox(height: 16.0),
                  Text(state.errorMessage),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(const LoadStores());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is StoreLoaded) {
          final query = state.searchQuery.toLowerCase();
          final categoryFilter = state.selectedCategory;
          final floorFilter = state.selectedFloor;

          // Filter stores based on search query, category, and floor
          final filteredStores = state.stores.where((store) {
            final matchesSearch = store.name.toLowerCase().contains(query) ||
                store.category.toLowerCase().contains(query);

            final matchesCategory = categoryFilter == 'All Stores' ||
                store.category.toLowerCase() == categoryFilter.toLowerCase();

            final matchesFloor = floorFilter == 'All Floors' ||
                store.floorText.toLowerCase().contains(floorFilter.toLowerCase());

            return matchesSearch && matchesCategory && matchesFloor;
          }).toList();

          // Featured Stores
          final featuredStores = state.stores.where((s) => s.id == 'zara' || s.id == 'hm').toList();

          // Trending Now
          final trendingStores = state.stores.where((s) => s.id == 'apple_store' || s.id == 'sephora' || s.id == 'lush').toList();

          return Stack(
            children: [
              // Scrollable content
              RefreshIndicator(
                onRefresh: () async {
                  context.read<StoreBloc>().add(const RefreshStores());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header height spacer
                      const SizedBox(height: 120.0),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 20.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              context.read<StoreBloc>().add(SearchStores(query: val));
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF7B7488)),
                              hintText: 'Search stores, brands, products...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF7B7488),
                                fontSize: 14.0,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.mic, color: Color(0xFF7B7488)),
                                    onPressed: () {},
                                  ),
                                  Container(width: 1.0, height: 24.0, color: const Color(0xFFCCC3D9).withOpacity(0.3)),
                                  IconButton(
                                    icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF7B7488)),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(color: Color(0xFFCCC3D9)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(color: Color(0xFFCCC3D9)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(color: Color(0xFF6100D6), width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Category scroll chips row
                      SizedBox(
                        height: 48.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          children: [
                            StoreCategoryChip(
                              text: 'All Stores',
                              isSelected: categoryFilter == 'All Stores',
                              onTap: () {
                                context.read<StoreBloc>().add(const FilterStoresCategory(category: 'All Stores'));
                              },
                            ),
                            StoreCategoryChip(
                              text: 'Fashion',
                              isSelected: categoryFilter == 'Fashion',
                              onTap: () {
                                context.read<StoreBloc>().add(const FilterStoresCategory(category: 'Fashion'));
                              },
                            ),
                            StoreCategoryChip(
                              text: 'Electronics',
                              isSelected: categoryFilter == 'Electronics',
                              onTap: () {
                                context.read<StoreBloc>().add(const FilterStoresCategory(category: 'Electronics'));
                              },
                            ),
                            StoreCategoryChip(
                              text: 'Footwear',
                              isSelected: categoryFilter == 'Footwear',
                              onTap: () {
                                context.read<StoreBloc>().add(const FilterStoresCategory(category: 'Footwear'));
                              },
                            ),
                            StoreCategoryChip(
                              text: 'Beauty',
                              isSelected: categoryFilter == 'Beauty',
                              onTap: () {
                                context.read<StoreBloc>().add(const FilterStoresCategory(category: 'Beauty'));
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Floor selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            const Text(
                              'Floor: ',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12.0, // label-sm
                                color: Color(0xFF4A4456), // on-surface-variant
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F1FF), // surface-container-low
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  _buildFloorButton(context, 'All Floors', floorFilter),
                                  _buildFloorButton(context, 'Ground', floorFilter),
                                  _buildFloorButton(context, 'L1', floorFilter),
                                  _buildFloorButton(context, 'L2', floorFilter),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Featured Brands
                      const StoreSectionTitle(
                        title: 'Featured Brands',
                        actionText: 'View All',
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 272.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: featuredStores.length,
                          itemBuilder: (context, index) {
                            final store = featuredStores[index];
                            return StoreCard.featured(
                              store: store,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoreDetailsPage(storeId: store.id),
                                  ),
                                );
                              },
                              onNavigate: () {},
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Trending Now
                      const StoreSectionTitle(title: 'Trending Now'),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 140.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: trendingStores.length,
                          itemBuilder: (context, index) {
                            final store = trendingStores[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoreDetailsPage(storeId: store.id),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140.0,
                                margin: const EdgeInsets.only(right: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0), // rounded-2xl
                                  border: Border.all(
                                    color: const Color(0xFFCCC3D9).withOpacity(0.3),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StoreLogo(logoUrl: store.logoUrl, size: 56.0, padding: 4.0),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      store.name,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D1A25),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      store.category.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A4456),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Browse All Stores List
                      StoreSectionTitle(
                        title: 'Browse All Stores',
                        customAction: Row(
                          children: [
                            const Icon(Icons.filter_list, size: 18.0, color: Color(0xFF6100D6)),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Sort',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6100D6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredStores.length,
                        itemBuilder: (context, index) {
                          final store = filteredStores[index];
                          return StoreCard.list(
                            store: store,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoreDetailsPage(storeId: store.id),
                                ),
                              );
                            },
                            onNavigate: () {},
                          );
                        },
                      ),

                      // Space at bottom
                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ),

              // Sticky AppBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8.0,
                    bottom: 16.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF7FF).withOpacity(0.85), // glass appbar
                    boxShadow: _isHeaderCollapsed
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10.0,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFF1D1A25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stores',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0, // headline-lg-mobile
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            if (!_isHeaderCollapsed)
                              const Text(
                                'Explore every store inside the mall',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11.0, // label-sm
                                  color: Color(0xFF4A4456), // on-surface-variant
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        color: const Color(0xFF6100D6),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFloorButton(BuildContext context, String label, String activeFloor) {
    final isSelected = activeFloor == label;
    return GestureDetector(
      onTap: () {
        context.read<StoreBloc>().add(FilterStoresFloor(floor: label));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF6100D6) : const Color(0xFF4A4456),
          ),
        ),
      ),
    );
  }
}

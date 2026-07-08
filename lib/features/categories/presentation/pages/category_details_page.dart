import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/category_local_datasource.dart';
import '../../data/repository/category_repository_impl.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/category_banner.dart';
import '../widgets/popular_store_card.dart';
import '../widgets/popular_brand_card.dart';
import '../widgets/featured_product_card.dart';
import '../widgets/offer_card.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = CategoryRepositoryImpl(
      localDataSource: CategoryLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => CategoryBloc(
        getCategories: GetCategories(repository),
        getCategoryDetails: GetCategoryDetails(repository),
        toggleCategoryProductFavorite: ToggleCategoryProductFavorite(repository),
        toggleFavoriteCategory: ToggleFavoriteCategory(repository),
      )..add(LoadCategoryDetails(categoryId: categoryId)),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // surface/background
        body: CategoryDetailsPageBody(),
      ),
    );
  }
}

class CategoryDetailsPageBody extends StatefulWidget {
  const CategoryDetailsPageBody({super.key});

  @override
  State<CategoryDetailsPageBody> createState() => _CategoryDetailsPageBodyState();
}

class _CategoryDetailsPageBodyState extends State<CategoryDetailsPageBody> {
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
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial || state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is CategoryError) {
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
                  const Text(
                    'Failed to load details',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      color: Color(0xFF4A4456),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6100D6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CategoryDetailsLoaded) {
          final details = state.categoryDetails;
          final activeFilter = state.activeFilter;
          final query = state.searchQuery.toLowerCase();

          // Search logic for dynamic local filtering
          final filteredStores = details.stores.where((store) {
            return store.name.toLowerCase().contains(query) ||
                store.floorText.toLowerCase().contains(query);
          }).toList();

          final filteredBrands = details.brands.where((brand) {
            return brand.name.toLowerCase().contains(query);
          }).toList();

          final filteredProducts = details.products.where((product) {
            return product.name.toLowerCase().contains(query) ||
                product.brandName.toLowerCase().contains(query);
          }).toList();

          final filteredOffers = details.offers.where((offer) {
            return offer.title.toLowerCase().contains(query) ||
                offer.tag.toLowerCase().contains(query) ||
                offer.description.toLowerCase().contains(query);
          }).toList();

          final showBanner = activeFilter == 'all' || activeFilter == 'offers';
          final showStores = (activeFilter == 'all' || activeFilter == 'stores') && filteredStores.isNotEmpty;
          final showBrands = (activeFilter == 'all' || activeFilter == 'brands') && filteredBrands.isNotEmpty;
          final showProducts = (activeFilter == 'all' || activeFilter == 'products') && filteredProducts.isNotEmpty;
          final showOffers = (activeFilter == 'all' || activeFilter == 'offers') && filteredOffers.isNotEmpty;

          return Stack(
            children: [
              // Scroll Content
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sticky Header Padding
                    SizedBox(height: MediaQuery.of(context).padding.top + 136.0),

                    // Quick Filters Horizontal Bar
                    SizedBox(
                      height: 52.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        children: [
                          _buildFilterTab(context, 'All', 'all', activeFilter),
                          const SizedBox(width: 12.0),
                          _buildFilterTab(context, 'Stores', 'stores', activeFilter),
                          const SizedBox(width: 12.0),
                          _buildFilterTab(context, 'Brands', 'brands', activeFilter),
                          const SizedBox(width: 12.0),
                          _buildFilterTab(context, 'Products', 'products', activeFilter),
                          const SizedBox(width: 12.0),
                          _buildFilterTab(context, 'Offers', 'offers', activeFilter),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // 1. Promotional Banner (e.g. Luxe Fashion Week)
                    if (showBanner && details.banners.isNotEmpty) ...[
                      CategoryBanner(
                        title: details.banners.first.title,
                        subtitle: details.banners.first.subtitle,
                        tag: details.banners.first.tag,
                        imageUrl: details.banners.first.imageUrl,
                      ),
                      const SizedBox(height: 40.0),
                    ],

                    // 2. Stores Section
                    if (showStores) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${details.category.title} Stores',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 20.0, // section-title
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            const Text(
                              'See All',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6100D6), // primary
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredStores.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            final store = filteredStores[index];
                            return PopularStoreCard(
                              store: store,
                              onNavigateTap: () {},
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],

                    // 3. Popular Brands Section
                    if (showBrands) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Text(
                          'Popular Brands',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20.0, // section-title
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: filteredBrands.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 24.0),
                          itemBuilder: (context, index) {
                            final brand = filteredBrands[index];
                            return PopularBrandCard(
                              brand: brand,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],

                    // 4. Trending Products Section
                    if (showProducts) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trending Products',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 20.0, // section-title
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            const Text(
                              'Explore',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6100D6), // primary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 370.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: filteredProducts.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 16.0),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Align(
                              alignment: Alignment.topLeft,
                              child: FeaturedProductCard(
                                product: product,
                                onFavoriteTap: () {
                                  context.read<CategoryBloc>().add(
                                        FavoriteCategoryProduct(
                                          categoryId: details.category.id,
                                          productId: product.id,
                                        ),
                                      );
                                },
                                onNavigateTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],

                    // 5. Current Offers Section
                    if (showOffers) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Text(
                          'Current Offers',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20.0, // section-title
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: filteredOffers.length,
                          itemBuilder: (context, index) {
                            final offer = filteredOffers[index];
                            return OfferCard(
                              offer: offer,
                              index: index,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],
                    const SizedBox(height: 100.0),
                  ],
                ),
              ),

              // Sticky AppBar & Search Bar Container
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
                    color: const Color(0xFFFEF7FF).withOpacity(0.85),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header title row
                      Row(
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
                            child: Text(
                              details.category.title,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0, // headline-lg-mobile
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            color: const Color(0xFF6100D6),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8.0),
                          // Avatar Match
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF7B2FF7), // primary-container
                                width: 2.0,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDXafzusEiBTsPP4wdJyVKpPK0CPwzBQLIXse6kpHodvqCmyAOzmKqKK-kOewcWmoZHxpYuc9XUnjzWAqrZ_wBmLIH3URyfYklJ8bsu9g8x9TySIQwdUJ2LBwUeYj6pHRiOSaa8qcvJwT2_uJ5_t2_qusdPn-kAt_l-GL74zzQ0b8hAUSMJtKFfQgONANlm9R0iZNxkI3oDDNupHmNds7gCKmcXLjXZsEwOE-Rv8givH3rRC0bDKNELSPpQio5jqXim76KWonz75g',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      // Search field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF), // bg-surface-container-lowest
                          borderRadius: BorderRadius.circular(28.0), // rounded-full
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            context.read<CategoryBloc>().add(
                                  SearchCategoriesQuery(query: value),
                                );
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search stores, brands, or products',
                            hintStyle: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF7B7488), // outline
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF7B7488), // outline
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
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

  Widget _buildFilterTab(
    BuildContext context,
    String label,
    String filterValue,
    String activeFilter,
  ) {
    final isSelected = activeFilter == filterValue;

    return GestureDetector(
      onTap: () {
        context.read<CategoryBloc>().add(FilterCategoryDetails(filter: filterValue));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999.0),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF6100D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFEDE5F5), // bg-surface-container-high
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B2FF7).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4A4456), // on-surface-variant
            ),
          ),
        ),
      ),
    );
  }
}

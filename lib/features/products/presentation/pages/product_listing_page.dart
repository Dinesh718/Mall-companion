import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/product_local_datasource.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/brand_chip.dart';
import '../widgets/featured_product_card.dart';
import '../widgets/product_card.dart';
import '../widgets/recommended_product_card.dart';
import '../widgets/section_title.dart';
import 'product_details_page.dart';

class ProductListingPage extends StatelessWidget {
  const ProductListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProductRepositoryImpl(
      localDataSource: ProductLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => ProductBloc(
        getProductsData: GetProductsData(repository),
        toggleProductWishlistUseCase: ToggleProductWishlistUseCase(repository),
      )..add(const LoadProducts()),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // surface
        body: ProductListingPageBody(),
      ),
    );
  }
}

class ProductListingPageBody extends StatefulWidget {
  const ProductListingPageBody({super.key});

  @override
  State<ProductListingPageBody> createState() => _ProductListingPageBodyState();
}

class _ProductListingPageBodyState extends State<ProductListingPageBody> {
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
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial || state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is ProductError) {
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
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(const LoadProducts());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ProductLoaded) {
          final query = state.searchQuery.toLowerCase();
          final categoryFilter = state.selectedCategory;
          final floorFilter = state.selectedFloor;

          // Filter listing products
          final filteredProducts = state.products.where((p) {
            final matchesQuery =
                p.name.toLowerCase().contains(query) ||
                p.brandName.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query);

            final matchesCategory =
                categoryFilter == 'All Products' ||
                p.category.toLowerCase() == categoryFilter.toLowerCase();

            final matchesFloor =
                floorFilter == 'All Floors' ||
                p.floorText.toLowerCase().contains(floorFilter.toLowerCase());

            return matchesQuery && matchesCategory && matchesFloor;
          }).toList();

          // Featured Products list
          final featuredProducts = state.products
              .where((p) => p.id == 'master_watch' || p.id == 'orbit_runner')
              .toList();

          // Trending Products list
          final trendingProducts = state.products
              .where(
                (p) =>
                    p.id == 'flora_perfume' ||
                    p.id == 'airposts_max' ||
                    p.id == 'airpods_max' ||
                    p.id == 'galleria_bag',
              )
              .toList();

          return Stack(
            children: [
              // Scrollable content
              RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductBloc>().add(const RefreshProducts());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Space spacer
                      const SizedBox(height: 120.0),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 20.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              context.read<ProductBloc>().add(
                                SearchProducts(query: val),
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF7B7488),
                              ),
                              hintText:
                                  'Search products, brands or categories...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF7B7488),
                                fontSize: 14.0,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.mic,
                                      color: Color(0xFF7B7488),
                                    ),
                                    onPressed: () {},
                                  ),
                                  Container(
                                    width: 1.0,
                                    height: 24.0,
                                    color: const Color(
                                      0xFFCCC3D9,
                                    ).withAlpha(76),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.qr_code_scanner,
                                      color: Color(0xFF7B7488),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFCCC3D9),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFCCC3D9),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6100D6),
                                  width: 2.0,
                                ),
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
                            BrandChip(
                              text: 'All Products',
                              isSelected: categoryFilter == 'All Products',
                              onTap: () {
                                context.read<ProductBloc>().add(
                                  const FilterProductsCategory(
                                    category: 'All Products',
                                  ),
                                );
                              },
                            ),
                            BrandChip(
                              text: 'Fashion',
                              isSelected: categoryFilter == 'Fashion',
                              onTap: () {
                                context.read<ProductBloc>().add(
                                  const FilterProductsCategory(
                                    category: 'Fashion',
                                  ),
                                );
                              },
                            ),
                            BrandChip(
                              text: 'Electronics',
                              isSelected: categoryFilter == 'Electronics',
                              onTap: () {
                                context.read<ProductBloc>().add(
                                  const FilterProductsCategory(
                                    category: 'Electronics',
                                  ),
                                );
                              },
                            ),
                            BrandChip(
                              text: 'Shoes',
                              isSelected: categoryFilter == 'Shoes',
                              onTap: () {
                                context.read<ProductBloc>().add(
                                  const FilterProductsCategory(
                                    category: 'Shoes',
                                  ),
                                );
                              },
                            ),
                            BrandChip(
                              text: 'Accessories',
                              isSelected: categoryFilter == 'Accessories',
                              onTap: () {
                                context.read<ProductBloc>().add(
                                  const FilterProductsCategory(
                                    category: 'Accessories',
                                  ),
                                );
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
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF9F1FF,
                                  ), // surface-container-low
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  children: [
                                    _buildFloorButton(
                                      context,
                                      'All Floors',
                                      floorFilter,
                                    ),
                                    _buildFloorButton(
                                      context,
                                      'Ground',
                                      floorFilter,
                                    ),
                                    _buildFloorButton(
                                      context,
                                      'L1',
                                      floorFilter,
                                    ),
                                    _buildFloorButton(
                                      context,
                                      'L2',
                                      floorFilter,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Featured Products section
                      const SectionTitle(
                        title: 'Featured Exclusives',
                        actionText: 'View All',
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 360.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: featuredProducts.length,
                          itemBuilder: (context, index) {
                            final product = featuredProducts[index];
                            return FeaturedProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsPage(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              onNavigate: () {},
                              onFavorite: () {
                                context.read<ProductBloc>().add(
                                  ToggleWishlist(productId: product.id),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Trending Products
                      const SectionTitle(title: 'Trending Now'),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 275.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: trendingProducts.length,
                          itemBuilder: (context, index) {
                            final product = trendingProducts[index];
                            return RecommendedProductCard(
                              product: product,
                              showBrandInfo: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsPage(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              onFavorite: () {
                                context.read<ProductBloc>().add(
                                  ToggleWishlist(productId: product.id),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // All Products List
                      const SectionTitle(title: 'All Products'),
                      const SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsPage(productId: product.id),
                                ),
                              );
                            },
                            onNavigate: () {},
                            onFavorite: () {
                              context.read<ProductBloc>().add(
                                ToggleWishlist(productId: product.id),
                              );
                            },
                          );
                        },
                      ),

                      // Space at bottom
                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ),

              // Sticky AppBar Navigation
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
                    color: const Color(
                      0xFFFEF7FF,
                    ).withOpacity(0.85), // glass appbar
                    boxShadow: _isHeaderCollapsed
                        ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
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
                              'The Galleria',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0, // headline-lg-mobile
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            if (!_isHeaderCollapsed)
                              const Text(
                                'Discover products available inside the mall',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11.0, // label-sm
                                  color: Color(
                                    0xFF4A4456,
                                  ), // on-surface-variant
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

  Widget _buildFloorButton(
    BuildContext context,
    String label,
    String activeFloor,
  ) {
    final isSelected = activeFloor == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ProductBloc>().add(FilterProductsFloor(floor: label));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF6100D6)
                  : const Color(0xFF4A4456),
            ),
          ),
        ),
      ),
    );
  }
}

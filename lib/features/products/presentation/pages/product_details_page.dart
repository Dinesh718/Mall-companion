import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/product_local_datasource.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/action_buttons.dart';
import '../widgets/product_banner.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_information_card.dart';
import '../widgets/product_review_card.dart';
import '../widgets/recommended_product_card.dart';
import '../widgets/section_title.dart';
import '../widgets/specification_card.dart';
import '../widgets/store_availability_card.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = ProductRepositoryImpl(
      localDataSource: ProductLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => ProductBloc(
        getProductsData: GetProductsData(repository),
        toggleProductWishlistUseCase: ToggleProductWishlistUseCase(repository),
      )..add(LoadProductDetails(productId: productId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF7FF), // surface
        body: ProductDetailsPageBody(productId: productId),
      ),
    );
  }
}

class ProductDetailsPageBody extends StatelessWidget {
  final String productId;

  const ProductDetailsPageBody({
    super.key,
    required this.productId,
  });

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
                  const Icon(Icons.error_outline, size: 64.0, color: Color(0xFFBA1A1A)),
                  const SizedBox(height: 16.0),
                  Text(state.errorMessage),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(LoadProductDetails(productId: productId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ProductDetailsLoaded) {
          final product = state.product;
          final recommended = state.recommendedProducts;

          return Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image
                    ProductBanner(product: product),

                    // Offset overlaps container sheet details
                    Transform.translate(
                      offset: const Offset(0, -32.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEF7FF), // surface-bright
                          borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24.0),

                            // Brand details & tag
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    product.category.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11.0, // label-sm
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6100D6),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(width: 4.0, height: 4.0, decoration: const BoxDecoration(color: Color(0xFFCCC3D9), shape: BoxShape.circle)),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    product.tag.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4456),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // Title & Price Info
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 24.0, // headline-lg-mobile
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D1A25),
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '${product.brandName} • Paris',
                                          style: const TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 14.0, // body-md
                                            color: Color(0xFF4A4456),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        textBaseline: TextBaseline.alphabetic,
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        children: [
                                          Text(
                                            '\$${product.price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6100D6),
                                            ),
                                          ),
                                          if (product.originalPrice != null) ...[
                                            const SizedBox(width: 6.0),
                                            Text(
                                              '\$${product.originalPrice!.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 14.0,
                                                color: Color(0xFF7B7488),
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFDAD6), // error-container
                                          borderRadius: BorderRadius.circular(9999.0),
                                        ),
                                        child: const Text(
                                          '15% Off - Limited Stock',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFBA1A1A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Description Info
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                product.description,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14.0, // body-md
                                  color: Color(0xFF4A4456),
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // Image Lookbook details gallery
                            ProductImageGallery(imageUrls: product.images),
                            const SizedBox(height: 24.0),

                            // Specifications card section
                            if (product.specifications.isNotEmpty) ...[
                              const SectionTitle(title: 'Specifications'),
                              const SizedBox(height: 12.0),
                              SpecificationCard(specifications: product.specifications),
                              const SizedBox(height: 32.0),
                            ],

                            // Store availability details
                            if (product.storeAvailability.isNotEmpty) ...[
                              const SectionTitle(title: 'Available At'),
                              const SizedBox(height: 12.0),
                              StoreAvailabilityCard(availability: product.storeAvailability.first),
                              const SizedBox(height: 32.0),
                            ],

                            // Indoor navigation preview map
                            const SectionTitle(title: 'Store Wayfinding'),
                            const SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 250.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 20.0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7XaPPPu0s9IOkwulmhgZBats-mkRgT8HVfre43OBaVfe8PW6hck2pYaCW5syI7au8KxOTBpGgCctJnKO1BUwRjkgkAAWtoeDhmeXyu3VMy2joHH1KhcM-YUx_1pGLL_vk21pF79KcKC9T_QQgs2bZEjMdheVpmbGi9eQE06fwHy8pELUxBO_p5PVbxjSiYiGwKb_3IdgUZC3576Xxc-KAMXxfKXo1NuzXtrPIsUExgZZyjRL7oCqisYMxuow-wayeqbiE2AWfMQ',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20.0,
                                      left: 20.0,
                                      right: 20.0,
                                      child: Container(
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(25),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.directions, color: Color(0xFF6100D6)),
                                            SizedBox(width: 8.0),
                                            Text(
                                              'Start Live Navigation',
                                              style: TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF6100D6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32.0),

                            // Reviews listing section
                            if (product.reviews.isNotEmpty) ...[
                              const SectionTitle(title: 'Reviews'),
                              const SizedBox(height: 12.0),
                              ...product.reviews.map((r) => ProductReviewCard(review: r)),
                              const SizedBox(height: 32.0),
                            ],

                            // Color & Sizes selections
                            ProductInformationCard(product: product),
                            const SizedBox(height: 32.0),

                            // Recommended Section
                            const SectionTitle(title: 'You May Also Like'),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              height: 275.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                itemCount: recommended.length,
                                itemBuilder: (context, index) {
                                  final rec = recommended[index];
                                  return RecommendedProductCard(
                                    product: rec,
                                    showBrandInfo: false,
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsPage(productId: rec.id),
                                        ),
                                      );
                                    },
                                    onFavorite: () {
                                      context.read<ProductBloc>().add(ToggleWishlist(productId: rec.id));
                                    },
                                  );
                                },
                              ),
                            ),

                            // Bottom Spacer
                            const SizedBox(height: 140.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky floating widgets overlays (Back / Share / Favorite)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16.0,
                left: 20.0,
                right: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Color(0xFF1D1A25)),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_outlined, color: Color(0xFF1D1A25)),
                        ),
                        const SizedBox(width: 12.0),
                        GestureDetector(
                          onTap: () {
                            context.read<ProductBloc>().add(ToggleWishlist(productId: product.id));
                          },
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              product.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: product.isFavorite ? const Color(0xFFBA1A1A) : const Color(0xFF6100D6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sticky footer Navigate actions
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ActionButtons(
                  onStore: () {},
                  onSave: () {
                    context.read<ProductBloc>().add(ToggleWishlist(productId: product.id));
                  },
                  onNavigate: () {},
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

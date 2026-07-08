import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/brand_local_datasource.dart';
import '../../data/repository/brand_repository_impl.dart';
import '../../domain/usecases/get_brands.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../widgets/brand_collection_card.dart';
import '../widgets/brand_product_card.dart';
import '../widgets/brand_section_title.dart';
import '../widgets/brand_store_card.dart';
import '../widgets/brand_story_card.dart';

class BrandDetailsPage extends StatelessWidget {
  final String brandId;

  const BrandDetailsPage({
    super.key,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    final datasource = BrandLocalDataSourceImpl();
    final repository = BrandRepositoryImpl(localDataSource: datasource);

    return BlocProvider(
      create: (_) => BrandBloc(
        getBrandsUseCase: GetBrandsUseCase(repository),
        getBrandDetailsUseCase: GetBrandDetailsUseCase(repository),
        getBrandProductsUseCase: GetBrandProductsUseCase(repository),
        getBrandStoresUseCase: GetBrandStoresUseCase(repository),
        getBrandCollectionsUseCase: GetBrandCollectionsUseCase(repository),
        getBrandReviewsUseCase: GetBrandReviewsUseCase(repository),
        getBrandOffersUseCase: GetBrandOffersUseCase(repository),
        toggleBrandFavoriteUseCase: ToggleBrandFavoriteUseCase(repository),
        toggleBrandFollowUseCase: ToggleBrandFollowUseCase(repository),
      )..add(LoadBrandDetails(brandId: brandId)),
      child: const _BrandDetailsPageBody(),
    );
  }
}

class _BrandDetailsPageBody extends StatelessWidget {
  const _BrandDetailsPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6100D6)),
            );
          }

          if (state is BrandDetailsLoaded) {
            final brand = state.brand;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large Hero Section (Image Banner + Overlay)
                      Stack(
                        children: [
                          SizedBox(
                            height: 480.0,
                            width: double.infinity,
                            child: Image.network(
                              brand.bannerUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          // Back Button
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 16.0,
                            left: 16.0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFF6100D6),
                                ),
                              ),
                            ),
                          ),
                          // Title & Favorite button
                          Positioned(
                            bottom: 24.0,
                            left: 24.0,
                            right: 24.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(100.0),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        child: const Text(
                                          'HAUTE COUTURE',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        brand.name,
                                        style: const TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<BrandBloc>().add(
                                          ToggleFavorite(
                                            brandId: brand.id,
                                            isDetailsPage: true,
                                          ),
                                        );
                                  },
                                  child: Container(
                                    width: 56.0,
                                    height: 56.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFEF7FF),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      brand.isFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_outline_rounded,
                                      color: const Color(0xFF6100D6),
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),

                      // Brand Story Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: BrandStoryCard(brand: brand),
                      ),
                      const SizedBox(height: 32.0),

                      // Available Stores
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: BrandSectionTitle(title: 'Available Stores'),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 220.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: state.stores.length,
                          itemBuilder: (context, index) {
                            final store = state.stores[index];

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: BrandStoreCard(
                                store: store,
                                isPrimaryStyle: index == 0,
                                onNavigateTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Guiding you to ${store.name} on ${store.levelText}...'),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Featured Lookbook Collections
                      if (state.collections.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: BrandSectionTitle(title: 'Featured Collections'),
                        ),
                        const SizedBox(height: 16.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: state.collections.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 3 / 4,
                          ),
                          itemBuilder: (context, index) {
                            final col = state.collections[index];
                            return BrandCollectionCard(collection: col);
                          },
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // Indoor Navigation Map Tracker widget
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F1FF),
                            borderRadius: BorderRadius.circular(32.0),
                            border: Border.all(
                              color: const Color(0xFFE8DFEF).withOpacity(0.5),
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Indoor mini map
                              Stack(
                                children: [
                                  Container(
                                    height: 256.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBeeYz_-YcPGSXPGIRCa52wMT0yxEyyNoAc5XEPzg0k2izG3pA32wE7ONBaLLyJ2eXnO5vBFNh3ZFhSrNUWv0xKbEd1NTzpV76Em3uyAysgd7sxkuTV5k-chESKWxKeSurOhtBnrxs5dP4IhD_818KgdBxySpVC0o6RELnnIsOtjx5IhgO2NJV8yA4uOVgWySFAjsrQDgn9aSznXWwdovSAzQBTZYN3MrIiWPY-Tvfon6bSB9AE8fd9zBWDxpjFaLkTw2WZXs0v4A',
                                      fit: BoxFit.cover,
                                      opacity: const AlwaysStoppedAnimation(0.65),
                                    ),
                                  ),
                                  // Location pin
                                  const Positioned.fill(
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            color: Color(0xFF6100D6),
                                            size: 32.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Distance indicator overlay banner
                                  Positioned(
                                    top: 16.0,
                                    left: 16.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: const Color(0xFFE8DFEF).withOpacity(0.5),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.location_on, color: Color(0xFF6100D6), size: 14.0),
                                          SizedBox(width: 4.0),
                                          Text(
                                            'Distance: 120m',
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 12.0,
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
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Precision Indoor Routing',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D1A25),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Text(
                                      'Real-time turn-by-turn guidance to the Luxury Atrium store.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.0,
                                        color: Color(0xFF4A4456),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Starting Live Navigation directions...')),
                                        );
                                      },
                                      child: Container(
                                        height: 52.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF6100D6), Color(0xFF2170E4)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(16.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6100D6).withOpacity(0.25),
                                              blurRadius: 15.0,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Start Live Navigation',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Popular In-Store Products List
                      if (state.products.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: BrandSectionTitle(title: 'Popular In-Store'),
                        ),
                        const SizedBox(height: 16.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final prod = state.products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: BrandProductCard(product: prod),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                // Sticky Bottom Action Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xFFE8DFEF).withOpacity(0.3),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 30.0,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom + 16.0,
                    ),
                    child: Row(
                      children: [
                        // Left icons
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.storefront_rounded, color: Color(0xFF4A4456)),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'STORES',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4456),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24.0),
                            GestureDetector(
                              onTap: () {},
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.share_rounded, color: Color(0xFF4A4456)),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'SHARE',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4456),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24.0),
                        Container(
                          width: 1.0,
                          height: 36.0,
                          color: const Color(0xFFCCC3D9),
                        ),
                        const SizedBox(width: 24.0),
                        // Right action button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Starting map routing directions...')),
                              );
                            },
                            child: Container(
                              height: 52.0,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6100D6), Color(0xFF2170E4)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6100D6).withOpacity(0.2),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_run_rounded, color: Colors.white, size: 20.0),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Navigate to Store',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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

          if (state is BrandError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

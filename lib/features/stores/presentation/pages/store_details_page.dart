import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/store_local_datasource.dart';
import '../../data/repository/store_repository_impl.dart';
import '../../domain/usecases/get_stores_usecase.dart';
import '../bloc/store_bloc.dart';
import '../bloc/store_event.dart';
import '../bloc/store_state.dart';
import '../widgets/store_action_buttons.dart';
import '../widgets/store_banner.dart';
import '../widgets/store_brand_card.dart';
import '../widgets/store_contact_card.dart';
import '../widgets/store_gallery.dart';
import '../widgets/store_information_card.dart';
import '../widgets/store_location_card.dart';
import '../widgets/store_offer_card.dart';
import '../widgets/store_product_card.dart';
import '../widgets/store_review_card.dart';
import '../widgets/store_section_title.dart';

class StoreDetailsPage extends StatelessWidget {
  final String storeId;

  const StoreDetailsPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    final repository = StoreRepositoryImpl(
      localDataSource: StoreLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => StoreBloc(
        getStoresData: GetStoresData(repository),
        toggleFavoriteStoreUseCase: ToggleFavoriteStoreUseCase(repository),
      )..add(LoadStoreDetails(storeId: storeId)),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // background/surface
        body: StoreDetailsPageBody(),
      ),
    );
  }
}

class StoreDetailsPageBody extends StatefulWidget {
  const StoreDetailsPageBody({super.key});

  @override
  State<StoreDetailsPageBody> createState() => _StoreDetailsPageBodyState();
}

class _StoreDetailsPageBodyState extends State<StoreDetailsPageBody> {
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderBlurred = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100.0) {
      if (!_isHeaderBlurred) {
        setState(() {
          _isHeaderBlurred = true;
        });
      }
    } else {
      if (_isHeaderBlurred) {
        setState(() {
          _isHeaderBlurred = false;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48.0,
                  color: Color(0xFFBA1A1A),
                ),
                const SizedBox(height: 16.0),
                Text(state.errorMessage),
              ],
            ),
          );
        }

        if (state is StoreDetailsLoaded) {
          final store = state.store;

          return Stack(
            children: [
              // Scrollable contents
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Banner
                    StoreBanner(store: store),
                    const SizedBox(height: 24.0),

                    // 2. Name & Category details header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.name,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24.0, // headline-lg-mobile
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D1A25), // on-surface
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 18.0,
                                      color: Color(0xFF4A4456),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      '${store.category} & Accessories',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14.0,
                                        color: Color(
                                          0xFF4A4456,
                                        ), // on-surface-variant
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6100D6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999.0),
                                side: const BorderSide(
                                  color: Color(0xFFCCC3D9),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                            ),
                            child: const Text(
                              'Contact',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // 3. Info boxes
                    StoreInformationCard(store: store),
                    const SizedBox(height: 20.0),

                    // 4. Description paragraph
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        store.description,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14.0,
                          height: 1.6,
                          color: Color(0xFF4A4456), // on-surface-variant
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // 5. Store Gallery Photos
                    if (store.gallery.isNotEmpty) ...[
                      const StoreSectionTitle(title: 'Store Gallery'),
                      const SizedBox(height: 16.0),
                      StoreGallery(imageUrls: store.gallery),
                      const SizedBox(height: 32.0),
                    ],

                    // 6. Available Collections (Brands)
                    if (store.brands.isNotEmpty) ...[
                      const StoreSectionTitle(title: 'Available Collections'),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 72.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: store.brands.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: StoreBrandCard(brand: store.brands[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],

                    // 7. Services bento grid
                    if (store.services.isNotEmpty) ...[
                      const StoreSectionTitle(title: 'Store Services'),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                childAspectRatio: 2.8,
                              ),
                          itemCount: store.services.length,
                          itemBuilder: (context, index) {
                            final service = store.services[index];
                            IconData icon = Icons.checkroom;
                            if (service.iconName == 'local_shipping')
                              icon = Icons.local_shipping;
                            if (service.iconName == 'featured_search')
                              icon = Icons.card_giftcard;
                            if (service.iconName == 'shopping_bag')
                              icon = Icons.shopping_bag;

                            return Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF3EBFA,
                                ), // surface-container
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: const Color(0xFF0058BE),
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      service.name,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D1A25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],

                    // 8. Limited Promotion banner card
                    if (store.offers.isNotEmpty) ...[
                      StoreOfferCard(offer: store.offers.first),
                      const SizedBox(height: 32.0),
                    ],

                    // 9. Trending Products
                    if (store.products.isNotEmpty) ...[
                      StoreSectionTitle(
                        title: 'Trending Now',
                        actionText: 'View Lookbook',
                        onActionTap: () {},
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 260.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: store.products.length,
                          itemBuilder: (context, index) {
                            return StoreProductCard(
                              product: store.products[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],

                    // 10. Wayfinding Map locations
                    const StoreSectionTitle(title: 'Location'),
                    const SizedBox(height: 16.0),
                    StoreLocationCard(store: store, onStartNavigation: () {}),
                    const SizedBox(height: 32.0),

                    // 11. Customer feedback reviews
                    if (store.reviews.isNotEmpty) ...[
                      const StoreSectionTitle(title: 'Recent Reviews'),
                      const SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: store.reviews.length,
                        itemBuilder: (context, index) {
                          return StoreReviewCard(review: store.reviews[index]);
                        },
                      ),
                    ],

                    // Buffer bottom spacing for sticky action buttons
                    const SizedBox(height: 120.0),
                  ],
                ),
              ),

              // Glass AppBar Navigation row
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8.0,
                    bottom: 12.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: _isHeaderBlurred
                        ? const Color(0xFFFEF7FF).withOpacity(0.85)
                        : Colors.transparent,
                    border: _isHeaderBlurred
                        ? Border(
                            bottom: BorderSide(
                              color: const Color(0xFFCCC3D9).withOpacity(0.15),
                              width: 1.0,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                      ),
                      // Actions (Share & Fav)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<StoreBloc>().add(
                                FavoriteStore(storeId: store.id),
                              );
                            },
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                store.isBookmarked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: store.isBookmarked
                                    ? const Color(0xFFBA1A1A)
                                    : const Color(0xFF1D1A25),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.share,
                                color: Color(0xFF1D1A25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Call/Share/Navigate buttons row
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StoreActionButtons(
                  onCall: () {},
                  onShare: () {},
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

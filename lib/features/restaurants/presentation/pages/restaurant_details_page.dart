import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_queue_ticket_page.dart';
import '../../data/datasource/restaurant_local_datasource.dart';
import '../../data/repository/restaurant_repository_impl.dart';
import '../../domain/entities/restaurant_entities.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';
import '../widgets/restaurant_action_buttons.dart';
import '../widgets/restaurant_gallery.dart';
import '../widgets/restaurant_info_card.dart';
import '../widgets/restaurant_menu_card.dart';
import '../widgets/restaurant_offer_card.dart';
import '../widgets/restaurant_rating_card.dart';
import '../widgets/restaurant_review_card.dart';
import '../widgets/restaurant_section_title.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

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
      )..add(LoadRestaurantDetails(restaurantId: restaurantId)),
      child: const _RestaurantDetailsBody(),
    );
  }
}

class _RestaurantDetailsBody extends StatefulWidget {
  const _RestaurantDetailsBody();

  @override
  State<_RestaurantDetailsBody> createState() => _RestaurantDetailsBodyState();
}

class _RestaurantDetailsBodyState extends State<_RestaurantDetailsBody> {
  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RestaurantDetailsLoaded) {
            final restaurant = state.restaurant;

            return Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Banner
                      Stack(
                        children: [
                          Image.network(
                            restaurant.imageUrl,
                            height: viewportHeight * 0.45,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: viewportHeight * 0.45,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Canvas Info Card Container (Overlapping)
                      Transform.translate(
                        offset: const Offset(0, -32.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 20.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: RestaurantInfoCard(restaurant: restaurant),
                          ),
                        ),
                      ),

                      // Live Status Bento Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: RestaurantRatingCard(restaurant: restaurant),
                      ),
                      const SizedBox(height: 32.0),

                      // Offers Coupon Carousel
                      if (restaurant.offers.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantSectionTitle(title: 'Active Offers'),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 140.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            clipBehavior: Clip.none,
                            itemCount: restaurant.offers.length,
                            itemBuilder: (context, index) {
                              return RestaurantOfferCard(
                                offer: restaurant.offers[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // Popular Dishes (Signature menu)
                      if (restaurant.menu.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantSectionTitle(
                            title: 'Signature Dishes',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 210.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            clipBehavior: Clip.none,
                            itemCount: restaurant.menu.length,
                            itemBuilder: (context, index) {
                              return RestaurantMenuCard(
                                item: restaurant.menu[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // Photos Gallery lookbook
                      if (restaurant.galleryUrls.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantSectionTitle(title: 'Gallery'),
                        ),
                        const SizedBox(height: 12.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantGallery(
                            imageUrls: restaurant.galleryUrls,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],

                      // Customer Reviews list
                      if (restaurant.reviews.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RestaurantSectionTitle(title: 'Guest Reviews'),
                        ),
                        const SizedBox(height: 12.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: restaurant.reviews
                                .map((r) => RestaurantReviewCard(review: r))
                                .toList(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 160.0),
                    ],
                  ),
                ),

                // Floating Back Header Button
                Positioned(
                  top: topPadding + 12.0,
                  left: 20.0,
                  right: 20.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sticky Bottom Actions overlay
                Positioned(
                  bottom: 24.0,
                  left: 20.0,
                  right: 20.0,
                  child: RestaurantActionButtons(
                    isFavorite: restaurant.isFavorite,
                    onNavigate: () {},
                    onReserve: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RestaurantQueueTicketPage(restaurant: restaurant),
                        ),
                      );
                    },
                    onFavorite: () {
                      context.read<RestaurantBloc>().add(
                        ToggleFavoriteRestaurant(restaurantId: restaurant.id),
                      );
                    },
                    onShare: () {},
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

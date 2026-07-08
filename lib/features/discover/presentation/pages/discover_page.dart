import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Usecases & Data Layer
import '../../data/datasource/discover_local_datasource.dart';
import '../../data/repository/discover_repository_impl.dart';
import '../../domain/usecases/get_discover_data.dart';

// BLoC
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';

// Custom Widgets
import '../widgets/category_grid.dart';
import '../widgets/discover_header.dart';
import '../widgets/discover_search_bar.dart';
import '../widgets/floor_filter.dart';
import '../widgets/nearby_amenities.dart';
import '../widgets/popular_stores.dart';
import '../widgets/popular_theatres.dart';
import '../widgets/promo_banner.dart';
import '../widgets/trending_dining.dart';
import 'events/event_listing_page.dart';
import '../../../theatres/presentation/pages/theatre_listing_page.dart';
import '../../../stores/presentation/pages/store_listing_page.dart';
import '../../../products/presentation/pages/product_listing_page.dart';
import '../../../restaurants/presentation/pages/restaurant_listing_page.dart';
import '../../../more/presentation/pages/more_page.dart';
import '../../../brands/presentation/pages/brand_listing_page.dart';
import '../../../categories/presentation/pages/category_listing_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverBloc(
        getDiscoverData: GetDiscoverData(
          DiscoverRepositoryImpl(
            localDataSource: DiscoverLocalDataSourceImpl(),
          ),
        ),
      )..add(const LoadDiscover()),
      child: const _DiscoverPageBody(),
    );
  }
}

class _DiscoverPageBody extends StatelessWidget {
  const _DiscoverPageBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverInitial || state is DiscoverLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is DiscoverError) {
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
                    'Failed to load Discover',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Color(0xFF4A4456),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DiscoverBloc>().add(const LoadDiscover());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6100D6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DiscoverLoaded) {
          final data = state.discoverData;
          final query = state.searchQuery.toLowerCase();
          final categoryFilter = state.selectedCategoryId;

          // 1. Dynamic Client-Side Filtering logic for Premium experience
          final filteredStores = data.popularStores.where((store) {
            final matchesQuery =
                store.name.toLowerCase().contains(query) ||
                store.category.toLowerCase().contains(query);

            // Map category grids to entity categories
            bool matchesCategory = true;
            if (categoryFilter == 'stores') {
              matchesCategory = true; // all stores match
            } else if (categoryFilter == 'brands') {
              matchesCategory =
                  store.category.toLowerCase().contains('brand') ||
                  store.name == 'Zudio';
            } else if (categoryFilter == 'products') {
              matchesCategory = false; // products placeholder
            } else if (categoryFilter.isNotEmpty && categoryFilter != 'more') {
              matchesCategory = store.category.toLowerCase().contains(
                categoryFilter,
              );
            }

            return matchesQuery && matchesCategory;
          }).toList();

          final filteredDining = data.trendingDining.where((restaurant) {
            final matchesQuery =
                restaurant.name.toLowerCase().contains(query) ||
                restaurant.cuisine.toLowerCase().contains(query);

            bool matchesCategory = true;
            if (categoryFilter.isNotEmpty) {
              matchesCategory =
                  categoryFilter == 'dining' ||
                  restaurant.cuisine.toLowerCase().contains(categoryFilter);
            }

            return matchesQuery && matchesCategory;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DiscoverBloc>().add(const RefreshDiscover());
            },
            color: const Color(0xFF6100D6),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Section
                  const DiscoverHeader(
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuA-2wdVyLj7SmNFV8wPBqf-KyEW9A4BPapnZy2HYBjmY3HgS-6Gak730iqDsHMsjoqOPBxtRtvJj2ctclzUqladIW_EzT_w2YgbJv_gKmCr_oHjNs73JPtlABq8cOtREVHuStgmMMoPIW6okzuVKJE57slrepCbZqvNQr_xDqrzkDW1lhE4g5QCClyrQ2MY5SGNHBdGO-aOa5EBIdct_uYUlOBbcshmeczcMD6LVg8UJDtUB82XiecKwfy1Z4JfMfTTTXP2WoFaTw',
                  ),
                  const SizedBox(height: 8.0),

                  // 2. Search Section
                  DiscoverSearchBar(
                    currentQuery: state.searchQuery,
                    onSearchChanged: (value) {
                      context.read<DiscoverBloc>().add(
                        SearchChanged(searchQuery: value),
                      );
                    },
                  ),
                  const SizedBox(height: 24.0),

                  // 3. Floor Filter dropdown
                  FloorFilter(
                    onFloorChanged: (floor) {
                      // Apply floor filter (can be used to filter lists later)
                    },
                  ),
                  const SizedBox(height: 24.0),

                  // 4. Category col-4 Grid list
                  CategoryGrid(
                    categories: data.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategorySelected: (catId) {
                      if (catId == 'events') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EventListingPage(),
                          ),
                        );
                      } else if (catId == 'theatres') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TheatreListingPage(),
                          ),
                        );
                      } else if (catId == 'stores') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StoreListingPage(),
                          ),
                        );
                      } else if (catId == 'products') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductListingPage(),
                          ),
                        );
                      } else if (catId == 'dining') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RestaurantListingPage(),
                          ),
                        );
                      } else if (catId == 'brands') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BrandListingPage(),
                          ),
                        );
                      } else if (catId == 'categories') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryListingPage(),
                          ),
                        );
                      } else if (catId == 'more') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MorePage()),
                        );
                      } else {
                        context.read<DiscoverBloc>().add(
                          SelectCategory(categoryId: catId),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32.0),

                  // 5. Popular Stores horizontal cards list
                  if (filteredStores.isNotEmpty) ...[
                    PopularStores(stores: filteredStores),
                    const SizedBox(height: 32.0),
                  ],

                  // 6. Trending Dining vertical list
                  if (filteredDining.isNotEmpty) ...[
                    TrendingDining(restaurants: filteredDining),
                    const SizedBox(height: 32.0),
                  ],

                  // 7. Nearby Amenities horizontal list
                  NearbyAmenities(amenities: data.amenities),
                  const SizedBox(height: 32.0),

                  // 8. Popular Theatres horizontal list
                  PopularTheatres(theatres: data.popularTheatres),
                  const SizedBox(height: 32.0),

                  // 9. Weekend Special Gradient Banner
                  const PromoBanner(),

                  // Extra spacing at the bottom to prevent clipping by sticky curved bottom nav bar
                  const SizedBox(height: 120.0),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

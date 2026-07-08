import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/category_local_datasource.dart';
import '../../data/repository/category_repository_impl.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/category_card.dart';
import '../widgets/featured_category_card.dart';
import '../widgets/subcategory_chip.dart';
import 'category_details_page.dart';

class CategoryListingPage extends StatelessWidget {
  const CategoryListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CategoryRepositoryImpl(
      localDataSource: CategoryLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => CategoryBloc(
        getCategories: GetCategories(repository),
        getCategoryDetails: GetCategoryDetails(repository),
        toggleCategoryProductFavorite: ToggleCategoryProductFavorite(
          repository,
        ),
        toggleFavoriteCategory: ToggleFavoriteCategory(repository),
      )..add(const LoadCategories()),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // surface/background
        body: CategoryListingPageBody(),
      ),
    );
  }
}

class CategoryListingPageBody extends StatefulWidget {
  const CategoryListingPageBody({super.key});

  @override
  State<CategoryListingPageBody> createState() =>
      _CategoryListingPageBodyState();
}

class _CategoryListingPageBodyState extends State<CategoryListingPageBody> {
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
                    'Failed to load Categories',
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
                      context.read<CategoryBloc>().add(const LoadCategories());
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

        if (state is CategoryLoaded) {
          final query = state.searchQuery.toLowerCase();
          final filter = state.selectedFilter;

          // Apply filters
          final filteredCategories = state.categories.where((cat) {
            final matchesQuery = cat.title.toLowerCase().contains(query);

            bool matchesFilter = true;
            if (filter != 'Trending Now') {
              matchesFilter = cat.title.toLowerCase() == filter.toLowerCase();
            }

            return matchesQuery && matchesFilter;
          }).toList();

          return Stack(
            children: [
              // Page content
              RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryBloc>().add(const RefreshCategories());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Space for sticky App Bar
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 76.0,
                      ),

                      // Title section
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categories',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 32.0, // headline-lg
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Explore shopping categories inside the mall',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16.0, // body-md
                                color: Color(0xFF4A4456), // on-surface-variant
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF7FF), // surface
                            borderRadius: BorderRadius.circular(
                              28.0,
                            ), // rounded-full
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20.0,
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
                            decoration: InputDecoration(
                              hintText: 'Search shopping categories...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF4A4456),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF4A4456),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.mic),
                                    color: const Color(0xFF4A4456),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.qr_code_scanner),
                                    color: const Color(0xFF4A4456),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Featured Category Hero
                      FeaturedCategoryCard(
                        title: 'Summer Fashion Collection',
                        tag: 'Editor\'s Pick',
                        description:
                            'Shop the latest fashion trends from world-renowned designers.',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBlRZr6F0uQjaD8KKNuDplwWrAlGehe8wdcuz59Jn9cLmyO7KF62dpHumARb36e0raWRAaPmwsO_b_939hzDvhHRpfNh8dAzj4cwngF3e-IrYpoykKwgkF8Mn6npEyGhflvbTpFt3m0MaahaaBeNttnGfCUJ67uCnau7dweKEWXpAXZs4wpHtHvNwxzJ_9fNZysmWQ4TNbJzVB2XvT2Y4btjJHvyzhwyw4LEWw5h76xDaXbU2ZaUdIjzuLQrQ0wb5s5hBlole-F-A',
                        onExploreTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CategoryDetailsPage(
                                categoryId: 'fashion',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32.0),

                      // Popular Choices Horizontal Scroll
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Popular Choices',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20.0, // section-title
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 52.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          children: [
                            SubcategoryChip(
                              label: 'Trending Now',
                              isSelected: filter == 'Trending Now',
                              icon: Icons.trending_up,
                              onTap: () {
                                context.read<CategoryBloc>().add(
                                  const FilterCategoryDetails(
                                    filter: 'Trending Now',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12.0),
                            SubcategoryChip(
                              label: 'Fashion',
                              isSelected: filter == 'Fashion',
                              icon: Icons.checkroom,
                              onTap: () {
                                context.read<CategoryBloc>().add(
                                  const FilterCategoryDetails(
                                    filter: 'Fashion',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12.0),
                            SubcategoryChip(
                              label: 'Electronics',
                              isSelected: filter == 'Electronics',
                              icon: Icons.devices,
                              onTap: () {
                                context.read<CategoryBloc>().add(
                                  const FilterCategoryDetails(
                                    filter: 'Electronics',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12.0),
                            SubcategoryChip(
                              label: 'Beauty',
                              isSelected: filter == 'Beauty',
                              icon: Icons.face_retouching_natural,
                              onTap: () {
                                context.read<CategoryBloc>().add(
                                  const FilterCategoryDetails(filter: 'Beauty'),
                                );
                              },
                            ),
                            const SizedBox(width: 12.0),
                            SubcategoryChip(
                              label: 'Dining',
                              isSelected: filter == 'Dining',
                              icon: Icons.restaurant,
                              onTap: () {
                                context.read<CategoryBloc>().add(
                                  const FilterCategoryDetails(filter: 'Dining'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Browse All Categories title
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Browse All Categories',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20.0, // section-title
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                      ),

                      // Grid Layout
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 0.95,
                              ),
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = filteredCategories[index];
                            return CategoryCard(
                              category: category,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryDetailsPage(
                                      categoryId: category.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ),

              // Sticky App Bar
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
                  child: Row(
                    children: [
                      // Avatar placeholder matching layout in code.html
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEADDFF), // primary-fixed
                            width: 2.0,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB3hHYhUXbl-pmR0C62IpZ4B7dWftuNSBH5he4Ch2vKlWcD5wLFGxRQSmVraWJh6E81N7hwXIkuJf4pR19fJ_KmJdX0PMcVZz87-276hTofPUbuxtYsdU17txASzWfQqxHgF8P3JcwdGqKr_OBtTrr24dfb9GNxbWCxDW6e3rGm5HAsb1ehGot-Pe2q9pHI9p6OhOEEZYRo8MOMyXRJjcUKw5XRgHoPRSZHhLwxKOSMrpY66RCJGTSd6_egItvpWeDZxuIstMIvsA',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Expanded(
                        child: Text(
                          'The Galleria',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24.0, // headline-lg-mobile
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFF1D1A25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
}

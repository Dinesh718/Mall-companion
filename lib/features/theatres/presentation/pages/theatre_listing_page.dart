import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/theatre_local_datasource.dart';
import '../../data/repository/theatre_repository_impl.dart';
import '../../domain/usecases/get_theatres_usecase.dart';
import '../bloc/theatre_bloc.dart';
import '../bloc/theatre_event.dart';
import '../bloc/theatre_state.dart';
import '../widgets/movie_banner.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_title.dart';
import 'theatre_details_page.dart';

class TheatreListingPage extends StatelessWidget {
  const TheatreListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = TheatreRepositoryImpl(
      localDataSource: TheatreLocalDataSourceImpl(),
    );

    return BlocProvider(
      create: (_) => TheatreBloc(
        getTheatresData: GetTheatresData(repository),
        toggleFavoriteMovieUseCase: ToggleFavoriteMovieUseCase(repository),
        bookTicketUseCase: BookTicketUseCase(repository),
      )..add(const LoadTheatres()),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // background
        body: TheatreListingPageBody(),
      ),
    );
  }
}

class TheatreListingPageBody extends StatefulWidget {
  const TheatreListingPageBody({super.key});

  @override
  State<TheatreListingPageBody> createState() => _TheatreListingPageBodyState();
}

class _TheatreListingPageBodyState extends State<TheatreListingPageBody> {
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
    return BlocBuilder<TheatreBloc, TheatreState>(
      builder: (context, state) {
        if (state is TheatreInitial || state is TheatreLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is TheatreError) {
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
                  Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TheatreBloc>().add(const LoadTheatres());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TheatreLoaded) {
          final query = state.searchQuery.toLowerCase();
          final categoryFilter = state.selectedCategory;
          final languageFilter = state.selectedLanguage;

          // 1. Featured Movie (Kingdom of the Planet of the Apes)
          final featuredMovie = state.movies.firstWhere(
            (m) => m.id == 'kingdom_planet_apes',
            orElse: () => state.movies.first,
          );

          // 2. Filter movies based on search, category and language
          final filteredMovies = state.movies.where((movie) {
            final matchesSearch =
                movie.title.toLowerCase().contains(query) ||
                movie.genre.toLowerCase().contains(query);

            final matchesCategory =
                categoryFilter == 'All' ||
                movie.category.toLowerCase() == categoryFilter.toLowerCase();

            bool matchesLanguage = true;
            if (languageFilter != 'All') {
              if (languageFilter == 'IMAX') {
                matchesLanguage = movie.showTimes.any((st) {
                  final theatre = state.theatres.firstWhere(
                    (t) => t.id == st.theatreId,
                  );
                  return theatre.facilities.any(
                    (f) => f.toUpperCase() == 'IMAX',
                  );
                });
              } else {
                matchesLanguage =
                    movie.language.toLowerCase() ==
                    languageFilter.toLowerCase();
              }
            }

            return matchesSearch && matchesCategory && matchesLanguage;
          }).toList();

          // 3. Now Showing list (for horizontal carousel)
          final nowShowingMovies = state.movies
              .where((m) => m.category == 'Now Showing')
              .toList();

          return Stack(
            children: [
              // Scrollable content
              RefreshIndicator(
                onRefresh: () async {
                  context.read<TheatreBloc>().add(const RefreshTheatres());
                },
                color: const Color(0xFF6100D6),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Space for the sticky app bar
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
                              context.read<TheatreBloc>().add(
                                SearchMovie(query: val),
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF7B7488), // outline
                              ),
                              hintText: 'Search movies, genres, languages...',
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
                                borderRadius: BorderRadius.circular(
                                  9999.0,
                                ), // pill
                                borderSide: const BorderSide(
                                  color: Color(0xFFCCC3D9),
                                ), // outline-variant
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

                      // Filter chips scroll list
                      SizedBox(
                        height: 48.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          children: [
                            _buildFilterChip(
                              text: 'Now Showing',
                              isSelected: categoryFilter == 'Now Showing',
                              onTap: () {
                                context.read<TheatreBloc>().add(
                                  const FilterMoviesCategory(
                                    category: 'Now Showing',
                                  ),
                                );
                              },
                            ),
                            _buildFilterChip(
                              text: 'Coming Soon',
                              isSelected: categoryFilter == 'Coming Soon',
                              onTap: () {
                                context.read<TheatreBloc>().add(
                                  const FilterMoviesCategory(
                                    category: 'Coming Soon',
                                  ),
                                );
                              },
                            ),
                            _buildFilterChip(
                              text: 'English',
                              isSelected: languageFilter == 'English',
                              onTap: () {
                                final nextLang = languageFilter == 'English'
                                    ? 'All'
                                    : 'English';
                                context.read<TheatreBloc>().add(
                                  FilterLanguage(language: nextLang),
                                );
                              },
                            ),
                            _buildFilterChip(
                              text: 'Tamil',
                              isSelected: languageFilter == 'Tamil',
                              onTap: () {
                                final nextLang = languageFilter == 'Tamil'
                                    ? 'All'
                                    : 'Tamil';
                                context.read<TheatreBloc>().add(
                                  FilterLanguage(language: nextLang),
                                );
                              },
                            ),
                            _buildFilterChip(
                              text: 'Hindi',
                              isSelected: languageFilter == 'Hindi',
                              onTap: () {
                                final nextLang = languageFilter == 'Hindi'
                                    ? 'All'
                                    : 'Hindi';
                                context.read<TheatreBloc>().add(
                                  FilterLanguage(language: nextLang),
                                );
                              },
                            ),
                            _buildFilterChip(
                              text: 'IMAX',
                              isSelected: languageFilter == 'IMAX',
                              onTap: () {
                                final nextLang = languageFilter == 'IMAX'
                                    ? 'All'
                                    : 'IMAX';
                                context.read<TheatreBloc>().add(
                                  FilterLanguage(language: nextLang),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),

                      // Featured Movie Banner
                      MovieBanner(
                        movie: featuredMovie,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TheatreDetailsPage(movieId: featuredMovie.id),
                            ),
                          );
                        },
                        onNavigate: () {},
                      ),
                      const SizedBox(height: 40.0),

                      // Now Showing Carousel Section
                      SectionTitle(
                        title: 'Now Showing',
                        actionText: 'See All →',
                        onActionTap: () {},
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 300.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: nowShowingMovies.length,
                          itemBuilder: (context, index) {
                            final m = nowShowingMovies[index];
                            return MovieCard.carousel(
                              movie: m,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TheatreDetailsPage(movieId: m.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Experience in LUXE Section
                      const SectionTitle(title: 'Experience in LUXE'),
                      const SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final m = filteredMovies[index];
                          return MovieCard.list(
                            movie: m,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TheatreDetailsPage(movieId: m.id),
                                ),
                              );
                            },
                            onNavigate: () {},
                          );
                        },
                      ),

                      // Buffer space
                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ),

              // Glass app bar (Fixed at top)
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
                    ).withOpacity(0.8), // glass-header background
                    boxShadow: _isHeaderCollapsed
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10.0,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFF1D1A25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      // Title Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Theatres',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24.0, // headline-lg-mobile
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1A25), // on-surface
                              ),
                            ),
                            if (!_isHeaderCollapsed)
                              const Text(
                                'Discover movies playing inside the mall',
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
                        color: const Color(0xFF1D1A25),
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

  Widget _buildFilterChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7423F0),
                Color(0xFF6100D6),
              ], // primary-gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(9999.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6100D6).withOpacity(0.15),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0, // label-sm
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F1FF), // surface-container-low
          borderRadius: BorderRadius.circular(9999.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.0, // label-sm
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4456), // on-surface-variant
          ),
        ),
      ),
    );
  }
}

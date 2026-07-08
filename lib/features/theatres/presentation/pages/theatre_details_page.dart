import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/theatre_local_datasource.dart';
import '../../data/repository/theatre_repository_impl.dart';
import '../../domain/usecases/get_theatres_usecase.dart';
import '../bloc/theatre_bloc.dart';
import '../bloc/theatre_event.dart';
import '../bloc/theatre_state.dart';
import '../widgets/action_button.dart';
import '../widgets/booking_button.dart';
import '../widgets/cast_card.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_info_card.dart';
import '../widgets/section_title.dart';
import '../widgets/theatre_info_card.dart';

class TheatreDetailsPage extends StatelessWidget {
  final String movieId;

  const TheatreDetailsPage({
    super.key,
    required this.movieId,
  });

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
      )..add(LoadMovieDetails(movieId: movieId)),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // background/surface
        body: TheatreDetailsPageBody(),
      ),
    );
  }
}

class TheatreDetailsPageBody extends StatefulWidget {
  const TheatreDetailsPageBody({super.key});

  @override
  State<TheatreDetailsPageBody> createState() => _TheatreDetailsPageBodyState();
}

class _TheatreDetailsPageBodyState extends State<TheatreDetailsPageBody> {
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderBlurred = false;
  String? _selectedShowTimeId;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48.0, color: Color(0xFFBA1A1A)),
                const SizedBox(height: 16.0),
                Text(state.errorMessage),
              ],
            ),
          );
        }

        if (state is TheatreDetailsLoaded) {
          final movie = state.movie;
          final theatres = state.theatres;
          final recommendations = state.recommendations;

          // Default selection of showtime if none is selected
          if (_selectedShowTimeId == null && movie.showTimes.isNotEmpty) {
            _selectedShowTimeId = movie.showTimes.first.id;
          }

          final activeShowTime = movie.showTimes.firstWhere(
            (st) => st.id == _selectedShowTimeId,
            orElse: () => movie.showTimes.first,
          );

          final activeTheatre = theatres.firstWhere(
            (t) => t.id == activeShowTime.theatreId,
            orElse: () => theatres.first,
          );

          return Stack(
            children: [
              // Page scrollable contents
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Header Banner image
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: double.infinity,
                          child: Image.network(
                            movie.bannerUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFEDE5F5),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.movie,
                                size: 80.0,
                                color: Color(0xFF6100D6),
                              ),
                            ),
                          ),
                        ),
                        // bottom gradient overlay fading to background color
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFFFEF7FF),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Title overlaid at bottom of hero
                        Positioned(
                          left: 20.0,
                          right: 20.0,
                          bottom: 16.0,
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1A25), // on-surface
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 2. Rating & Synopsis Box
                    MovieInfoCard(movie: movie),
                    const SizedBox(height: 32.0),

                    // 3. Top Cast list
                    if (movie.cast.isNotEmpty) ...[
                      const SectionTitle(title: 'Top Cast'),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 140.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: movie.cast.length,
                          itemBuilder: (context, index) {
                            final cast = movie.cast[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: CastCard(castMember: cast),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],

                    // 4. Cinema Info & Timings selection card
                    TheatreInfoCard(
                      theatre: activeTheatre,
                      showTimes: movie.showTimes,
                      selectedShowTimeId: _selectedShowTimeId,
                      onShowTimeSelected: (id) {
                        setState(() {
                          _selectedShowTimeId = id;
                        });
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // 5. Wayfinding Navigation Preview Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 192.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0), // rounded-[24px]
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                activeTheatre.mapImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ),
                            // Floating bottom bar path detail overlay
                            Positioned(
                              left: 12.0,
                              right: 12.0,
                              bottom: 12.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF7FF).withOpacity(0.8), // glass overlay
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32.0,
                                          height: 32.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6100D6).withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.directions_walk,
                                            color: Color(0xFF6100D6),
                                            size: 18.0,
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activeTheatre.distanceWalkText,
                                              style: const TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1D1A25),
                                              ),
                                            ),
                                            Text(
                                              activeTheatre.floorText,
                                              style: const TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 11.0,
                                                color: Color(0xFF4A4456),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF6100D6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    // 6. Recommended Movies
                    if (recommendations.isNotEmpty) ...[
                      const SectionTitle(title: 'Similar at PVR'),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 300.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: recommendations.length,
                          itemBuilder: (context, index) {
                            final rMovie = recommendations[index];
                            return MovieCard.carousel(
                              movie: rMovie,
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TheatreDetailsPage(movieId: rMovie.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    // Buffer space for sticky bottom bar
                    const SizedBox(height: 120.0),
                  ],
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
                    bottom: 12.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: _isHeaderBlurred
                        ? const Color(0xFFFEF7FF).withOpacity(0.8)
                        : Colors.transparent,
                    border: _isHeaderBlurred
                        ? const Border(
                            bottom: BorderSide(
                              color: Color(0x1FCCC3D9),
                              width: 1.0,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      ActionButton(
                        icon: Icons.arrow_back,
                        isTransparent: !_isHeaderBlurred,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      // Actions (Share & Fav)
                      Row(
                        children: [
                          ActionButton(
                            icon: Icons.share,
                            isTransparent: !_isHeaderBlurred,
                            onTap: () {
                              context.read<TheatreBloc>().add(SearchMovie(query: movie.title)); // simulation
                            },
                          ),
                          const SizedBox(width: 8.0),
                          ActionButton(
                            icon: movie.isBookmarked ? Icons.favorite : Icons.favorite_border,
                            isFav: movie.isBookmarked,
                            isTransparent: !_isHeaderBlurred,
                            onTap: () {
                              context.read<TheatreBloc>().add(FavoriteMovie(movieId: movie.id));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Book Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom + 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF7FF).withOpacity(0.8), // glass overlay
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFCCC3D9).withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: BookingButton(
                          text: 'Navigate to Theatre',
                          icon: Icons.near_me,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE5F5), // surface-container-high
                            borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                            border: Border.all(
                              color: const Color(0xFFCCC3D9).withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.share_outlined,
                            color: Color(0xFF1D1A25),
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
}

import '../../domain/entities/theatre_entities.dart';

abstract class TheatreState {
  const TheatreState();
}

class TheatreInitial extends TheatreState {
  const TheatreInitial();
}

class TheatreLoading extends TheatreState {
  const TheatreLoading();
}

class TheatreLoaded extends TheatreState {
  final List<MovieEntity> movies;
  final List<TheatreEntity> theatres;
  final String searchQuery;
  final String selectedCategory; // 'All', 'Now Showing', 'Coming Soon'
  final String selectedLanguage; // 'All', 'English', 'Tamil', 'Hindi', 'IMAX'

  const TheatreLoaded({
    required this.movies,
    required this.theatres,
    this.searchQuery = '',
    this.selectedCategory = 'Now Showing', // default active chip in Stitch design
    this.selectedLanguage = 'All',
  });

  TheatreLoaded copyWith({
    List<MovieEntity>? movies,
    List<TheatreEntity>? theatres,
    String? searchQuery,
    String? selectedCategory,
    String? selectedLanguage,
  }) {
    return TheatreLoaded(
      movies: movies ?? this.movies,
      theatres: theatres ?? this.theatres,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

class TheatreDetailsLoaded extends TheatreState {
  final MovieEntity movie;
  final List<TheatreEntity> theatres;
  final List<MovieEntity> recommendations;

  const TheatreDetailsLoaded({
    required this.movie,
    required this.theatres,
    required this.recommendations,
  });

  TheatreDetailsLoaded copyWith({
    MovieEntity? movie,
    List<TheatreEntity>? theatres,
    List<MovieEntity>? recommendations,
  }) {
    return TheatreDetailsLoaded(
      movie: movie ?? this.movie,
      theatres: theatres ?? this.theatres,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

class TheatreError extends TheatreState {
  final String errorMessage;
  const TheatreError({required this.errorMessage});
}

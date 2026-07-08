abstract class TheatreEvent {
  const TheatreEvent();
}

class LoadTheatres extends TheatreEvent {
  const LoadTheatres();
}

class RefreshTheatres extends TheatreEvent {
  const RefreshTheatres();
}

class LoadMovieDetails extends TheatreEvent {
  final String movieId;
  const LoadMovieDetails({required this.movieId});
}

class SearchMovie extends TheatreEvent {
  final String query;
  const SearchMovie({required this.query});
}

class FilterMoviesCategory extends TheatreEvent {
  final String category; // 'All', 'Now Showing', 'Coming Soon'
  const FilterMoviesCategory({required this.category});
}

class FilterLanguage extends TheatreEvent {
  final String language; // 'All', 'English', 'Tamil', 'Hindi', 'IMAX'
  const FilterLanguage({required this.language});
}

class FavoriteMovie extends TheatreEvent {
  final String movieId;
  const FavoriteMovie({required this.movieId});
}

class BookMovie extends TheatreEvent {
  final String showTimeId;
  const BookMovie({required this.showTimeId});
}

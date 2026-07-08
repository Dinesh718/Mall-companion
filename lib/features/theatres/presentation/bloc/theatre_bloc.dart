import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_theatres_usecase.dart';
import 'theatre_event.dart';
import 'theatre_state.dart';

class TheatreBloc extends Bloc<TheatreEvent, TheatreState> {
  final GetTheatresData getTheatresData;
  final ToggleFavoriteMovieUseCase toggleFavoriteMovieUseCase;
  final BookTicketUseCase bookTicketUseCase;

  TheatreBloc({
    required this.getTheatresData,
    required this.toggleFavoriteMovieUseCase,
    required this.bookTicketUseCase,
  }) : super(const TheatreInitial()) {
    on<LoadTheatres>(_onLoadTheatres);
    on<RefreshTheatres>(_onRefreshTheatres);
    on<LoadMovieDetails>(_onLoadMovieDetails);
    on<SearchMovie>(_onSearchMovie);
    on<FilterMoviesCategory>(_onFilterMoviesCategory);
    on<FilterLanguage>(_onFilterLanguage);
    on<FavoriteMovie>(_onFavoriteMovie);
    on<BookMovie>(_onBookMovie);
  }

  Future<void> _onLoadTheatres(
    LoadTheatres event,
    Emitter<TheatreState> emit,
  ) async {
    emit(const TheatreLoading());
    try {
      final movies = await getTheatresData.getMovies();
      final theatres = await getTheatresData.getTheatres();
      emit(TheatreLoaded(movies: movies, theatres: theatres));
    } catch (e) {
      emit(TheatreError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshTheatres(
    RefreshTheatres event,
    Emitter<TheatreState> emit,
  ) async {
    final currentState = state;
    try {
      final movies = await getTheatresData.getMovies();
      final theatres = await getTheatresData.getTheatres();
      if (currentState is TheatreLoaded) {
        emit(currentState.copyWith(movies: movies, theatres: theatres));
      } else {
        emit(TheatreLoaded(movies: movies, theatres: theatres));
      }
    } catch (e) {
      emit(TheatreError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<TheatreState> emit,
  ) async {
    emit(const TheatreLoading());
    try {
      final movies = await getTheatresData.getMovies();
      final theatres = await getTheatresData.getTheatres();
      final movie = movies.firstWhere((m) => m.id == event.movieId);
      final recommendations = movies
          .where((m) => m.id != event.movieId)
          .toList();
      emit(
        TheatreDetailsLoaded(
          movie: movie,
          theatres: theatres,
          recommendations: recommendations,
        ),
      );
    } catch (e) {
      emit(TheatreError(errorMessage: e.toString()));
    }
  }

  void _onSearchMovie(SearchMovie event, Emitter<TheatreState> emit) {
    final currentState = state;
    if (currentState is TheatreLoaded) {
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  void _onFilterMoviesCategory(
    FilterMoviesCategory event,
    Emitter<TheatreState> emit,
  ) {
    final currentState = state;
    if (currentState is TheatreLoaded) {
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  void _onFilterLanguage(FilterLanguage event, Emitter<TheatreState> emit) {
    final currentState = state;
    if (currentState is TheatreLoaded) {
      emit(currentState.copyWith(selectedLanguage: event.language));
    }
  }

  Future<void> _onFavoriteMovie(
    FavoriteMovie event,
    Emitter<TheatreState> emit,
  ) async {
    final currentState = state;
    try {
      await toggleFavoriteMovieUseCase(event.movieId);
      final movies = await getTheatresData.getMovies();

      if (currentState is TheatreLoaded) {
        emit(currentState.copyWith(movies: movies));
      } else if (currentState is TheatreDetailsLoaded) {
        final updatedMovie = movies.firstWhere((m) => m.id == event.movieId);
        emit(currentState.copyWith(movie: updatedMovie));
      }
    } catch (e) {
      emit(TheatreError(errorMessage: e.toString()));
    }
  }

  Future<void> _onBookMovie(BookMovie event, Emitter<TheatreState> emit) async {
    try {
      await bookTicketUseCase(event.showTimeId);
      // In a real application, we might update seats availability and emit success.
      // Here, we just keep current state.
    } catch (e) {
      emit(TheatreError(errorMessage: e.toString()));
    }
  }
}

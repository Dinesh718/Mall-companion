import '../entities/theatre_entities.dart';
import '../repository/theatre_repository.dart';

class GetTheatresData {
  final TheatreRepository repository;

  GetTheatresData(this.repository);

  Future<List<MovieEntity>> getMovies() async {
    return await repository.getMovies();
  }

  Future<List<TheatreEntity>> getTheatres() async {
    return await repository.getTheatres();
  }
}

class ToggleFavoriteMovieUseCase {
  final TheatreRepository repository;

  ToggleFavoriteMovieUseCase(this.repository);

  Future<void> call(String movieId) async {
    await repository.toggleFavoriteMovie(movieId);
  }
}

class BookTicketUseCase {
  final TheatreRepository repository;

  BookTicketUseCase(this.repository);

  Future<void> call(String showTimeId) async {
    await repository.bookTicket(showTimeId);
  }
}

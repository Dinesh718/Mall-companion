import '../entities/theatre_entities.dart';

abstract class TheatreRepository {
  Future<List<MovieEntity>> getMovies();
  Future<List<TheatreEntity>> getTheatres();
  Future<void> toggleFavoriteMovie(String id);
  Future<void> bookTicket(String showTimeId);
}

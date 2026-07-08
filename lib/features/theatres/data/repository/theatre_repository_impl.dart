import '../../domain/entities/theatre_entities.dart';
import '../../domain/repository/theatre_repository.dart';
import '../datasource/theatre_local_datasource.dart';

class TheatreRepositoryImpl implements TheatreRepository {
  final TheatreLocalDataSource localDataSource;

  TheatreRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MovieEntity>> getMovies() async {
    return await localDataSource.getMovies();
  }

  @override
  Future<List<TheatreEntity>> getTheatres() async {
    return await localDataSource.getTheatres();
  }

  @override
  Future<void> toggleFavoriteMovie(String id) async {
    await localDataSource.toggleFavoriteMovie(id);
  }

  @override
  Future<void> bookTicket(String showTimeId) async {
    await localDataSource.bookTicket(showTimeId);
  }
}

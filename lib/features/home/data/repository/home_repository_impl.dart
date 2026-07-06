import '../../domain/entities/home_entities.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<HomeDataEntity> getHomeData() async {
    return await localDataSource.getHomeData();
  }
}

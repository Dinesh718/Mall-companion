import '../../domain/entities/more_entities.dart';
import '../../domain/repository/more_repository.dart';
import '../datasource/more_local_datasource.dart';

class MoreRepositoryImpl implements MoreRepository {
  final MoreLocalDataSource localDataSource;
  MoreRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    return await localDataSource.getUserProfile();
  }

  @override
  Future<List<QuickActionEntity>> getQuickActions() async {
    return await localDataSource.getQuickActions();
  }

  @override
  Future<List<MallServiceEntity>> getMallServices() async {
    return await localDataSource.getMallServices();
  }

  @override
  Future<List<PopularServiceEntity>> getPopularServices() async {
    return await localDataSource.getPopularServices();
  }

  @override
  Future<List<ParkingFloorEntity>> getParkingFloors() async {
    return await localDataSource.getParkingFloors();
  }

  @override
  Future<List<AmenityItemEntity>> getAmenities() async {
    return await localDataSource.getAmenities();
  }

  @override
  Future<void> submitFeedback(String rating, String comments) async {
    await localDataSource.submitFeedback(rating, comments);
  }
}

import '../entities/more_entities.dart';

abstract class MoreRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<List<QuickActionEntity>> getQuickActions();
  Future<List<MallServiceEntity>> getMallServices();
  Future<List<PopularServiceEntity>> getPopularServices();
  Future<List<ParkingFloorEntity>> getParkingFloors();
  Future<List<AmenityItemEntity>> getAmenities();
  Future<void> submitFeedback(String rating, String comments);
}

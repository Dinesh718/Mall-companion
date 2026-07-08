import '../entities/more_entities.dart';
import '../repository/more_repository.dart';

class GetUserProfileUseCase {
  final MoreRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call() async {
    return await repository.getUserProfile();
  }
}

class GetQuickActionsUseCase {
  final MoreRepository repository;
  GetQuickActionsUseCase(this.repository);

  Future<List<QuickActionEntity>> call() async {
    return await repository.getQuickActions();
  }
}

class GetMallServicesUseCase {
  final MoreRepository repository;
  GetMallServicesUseCase(this.repository);

  Future<List<MallServiceEntity>> call() async {
    return await repository.getMallServices();
  }
}

class GetPopularServicesUseCase {
  final MoreRepository repository;
  GetPopularServicesUseCase(this.repository);

  Future<List<PopularServiceEntity>> call() async {
    return await repository.getPopularServices();
  }
}

class GetParkingFloorsUseCase {
  final MoreRepository repository;
  GetParkingFloorsUseCase(this.repository);

  Future<List<ParkingFloorEntity>> call() async {
    return await repository.getParkingFloors();
  }
}

class GetAmenitiesUseCase {
  final MoreRepository repository;
  GetAmenitiesUseCase(this.repository);

  Future<List<AmenityItemEntity>> call() async {
    return await repository.getAmenities();
  }
}

class SubmitFeedbackUseCase {
  final MoreRepository repository;
  SubmitFeedbackUseCase(this.repository);

  Future<void> call(String rating, String comments) async {
    await repository.submitFeedback(rating, comments);
  }
}

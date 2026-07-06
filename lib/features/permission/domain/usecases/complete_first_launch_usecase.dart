import '../repositories/permission_repository.dart';

class CompleteFirstLaunchUseCase {
  final PermissionRepository repository;

  CompleteFirstLaunchUseCase(this.repository);

  Future<void> call() async {
    await repository.setFirstLaunchCompleted();
  }
}

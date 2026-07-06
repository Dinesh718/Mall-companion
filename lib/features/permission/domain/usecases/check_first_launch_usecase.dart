import '../repositories/permission_repository.dart';

class CheckFirstLaunchUseCase {
  final PermissionRepository repository;

  CheckFirstLaunchUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isFirstLaunch();
  }
}

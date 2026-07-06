import '../repositories/permission_repository.dart';

class CheckRequiredPermissionsUseCase {
  final PermissionRepository repository;

  CheckRequiredPermissionsUseCase(this.repository);

  Future<bool> call() async {
    return await repository.areRequiredPermissionsGranted();
  }
}

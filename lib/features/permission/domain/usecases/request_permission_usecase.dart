import 'package:permission_handler/permission_handler.dart';
import '../repositories/permission_repository.dart';

class RequestPermissionUseCase {
  final PermissionRepository repository;

  RequestPermissionUseCase(this.repository);

  Future<PermissionStatus> call(Permission permission) async {
    return await repository.requestPermission(permission);
  }
}

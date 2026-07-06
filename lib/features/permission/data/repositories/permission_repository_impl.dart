import 'package:permission_handler/permission_handler.dart';
import '../../domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  @override
  Future<bool> isFirstLaunch() async {
    // Stubbed for now, architecture ready for persistent storage later
    return true;
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    // Stubbed for now, architecture ready for persistent storage later
  }

  @override
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  @override
  Future<bool> areRequiredPermissionsGranted() async {
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;
    return locationStatus.isGranted && cameraStatus.isGranted;
  }
}

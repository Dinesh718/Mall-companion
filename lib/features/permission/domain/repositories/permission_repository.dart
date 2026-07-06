import 'package:permission_handler/permission_handler.dart';

abstract class PermissionRepository {
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
  Future<PermissionStatus> getPermissionStatus(Permission permission);
  Future<PermissionStatus> requestPermission(Permission permission);
  Future<bool> areRequiredPermissionsGranted();
}

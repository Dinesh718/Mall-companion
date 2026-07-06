import 'package:flutter/foundation.dart';

@immutable
sealed class PermissionEvent {
  const PermissionEvent();
}

class CheckPermissionsStatus extends PermissionEvent {
  const CheckPermissionsStatus();
}

class RequestLocationPermission extends PermissionEvent {
  const RequestLocationPermission();
}

class LocationPermissionDenied extends PermissionEvent {
  const LocationPermissionDenied();
}

class RequestCameraPermission extends PermissionEvent {
  const RequestCameraPermission();
}

class CameraPermissionDenied extends PermissionEvent {
  const CameraPermissionDenied();
}

class RequestNotificationPermission extends PermissionEvent {
  const RequestNotificationPermission();
}

class SkipNotificationPermission extends PermissionEvent {
  const SkipNotificationPermission();
}

class UpdatePageIndex extends PermissionEvent {
  final int index;
  const UpdatePageIndex(this.index);
}

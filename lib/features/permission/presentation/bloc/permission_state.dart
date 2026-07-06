import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionRequestStatus {
  initial,
  loading,
  granted,
  denied,
  permanentlyDenied,
  navigateNext,
}

@immutable
class PermissionState {
  final int currentPageIndex;
  final PermissionRequestStatus status;
  final Permission? currentPermissionType;
  final String? message;
  final bool locationGranted;
  final bool cameraGranted;
  final bool notificationGranted;

  const PermissionState({
    required this.currentPageIndex,
    required this.status,
    this.currentPermissionType,
    this.message,
    required this.locationGranted,
    required this.cameraGranted,
    required this.notificationGranted,
  });

  factory PermissionState.initial() {
    return const PermissionState(
      currentPageIndex: 0,
      status: PermissionRequestStatus.initial,
      locationGranted: false,
      cameraGranted: false,
      notificationGranted: false,
    );
  }

  PermissionState copyWith({
    int? currentPageIndex,
    PermissionRequestStatus? status,
    Permission? currentPermissionType,
    String? message,
    bool? locationGranted,
    bool? cameraGranted,
    bool? notificationGranted,
  }) {
    return PermissionState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      status: status ?? this.status,
      currentPermissionType:
          currentPermissionType ?? this.currentPermissionType,
      message: message ?? this.message,
      locationGranted: locationGranted ?? this.locationGranted,
      cameraGranted: cameraGranted ?? this.cameraGranted,
      notificationGranted: notificationGranted ?? this.notificationGranted,
    );
  }
}

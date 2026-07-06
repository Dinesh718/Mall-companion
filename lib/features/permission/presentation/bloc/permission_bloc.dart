import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/usecases/request_permission_usecase.dart';
import '../../data/repositories/permission_repository_impl.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final RequestPermissionUseCase requestPermissionUseCase;

  PermissionBloc({RequestPermissionUseCase? requestPermissionUseCase})
    : requestPermissionUseCase =
          requestPermissionUseCase ??
          RequestPermissionUseCase(PermissionRepositoryImpl()),
      super(PermissionState.initial()) {
    on<CheckPermissionsStatus>(_onCheckPermissionsStatus);
    on<RequestLocationPermission>(_onRequestLocation);
    on<LocationPermissionDenied>(_onLocationPermissionDenied);
    on<RequestCameraPermission>(_onRequestCamera);
    on<CameraPermissionDenied>(_onCameraPermissionDenied);
    on<RequestNotificationPermission>(_onRequestNotification);
    on<SkipNotificationPermission>(_onSkipNotification);
    on<UpdatePageIndex>(_onUpdatePageIndex);

    // Trigger initial check on creation
    add(const CheckPermissionsStatus());
  }

  Future<void> _onCheckPermissionsStatus(
    CheckPermissionsStatus event,
    Emitter<PermissionState> emit,
  ) async {
    final repository = requestPermissionUseCase.repository;

    final locationStatus = await repository.getPermissionStatus(
      Permission.location,
    );
    final cameraStatus = await repository.getPermissionStatus(
      Permission.camera,
    );
    final notificationStatus = await repository.getPermissionStatus(
      Permission.notification,
    );

    final locationGranted = locationStatus.isGranted;
    final cameraGranted = cameraStatus.isGranted;
    final notificationGranted = notificationStatus.isGranted;

    int initialIndex = 0;
    if (locationGranted) {
      initialIndex = 1;
      if (cameraGranted) {
        initialIndex = 2;
      }
    }

    emit(
      state.copyWith(
        locationGranted: locationGranted,
        cameraGranted: cameraGranted,
        notificationGranted: notificationGranted,
        currentPageIndex: initialIndex,
        status: PermissionRequestStatus.initial,
      ),
    );
  }

  Future<void> _onRequestLocation(
    RequestLocationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PermissionRequestStatus.loading,
        currentPermissionType: Permission.location,
      ),
    );

    try {
      final status = await requestPermissionUseCase(Permission.location);
      if (status.isGranted) {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.granted,
            locationGranted: true,
            currentPageIndex: 1, // Advance to Camera
          ),
        );
      } else if (status.isPermanentlyDenied) {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.permanentlyDenied,
            locationGranted: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.denied,
            locationGranted: false,
            message: 'Location access is required to navigate the mall.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionRequestStatus.denied,
          message: 'An error occurred while requesting location access.',
        ),
      );
    }
  }

  void _onLocationPermissionDenied(
    LocationPermissionDenied event,
    Emitter<PermissionState> emit,
  ) {
    emit(
      state.copyWith(
        status: PermissionRequestStatus.denied,
        message: 'Location access is required to navigate the mall.',
      ),
    );
  }

  Future<void> _onRequestCamera(
    RequestCameraPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PermissionRequestStatus.loading,
        currentPermissionType: Permission.camera,
      ),
    );

    try {
      final status = await requestPermissionUseCase(Permission.camera);
      if (status.isGranted) {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.granted,
            cameraGranted: true,
            currentPageIndex: 2, // Advance to Notification
          ),
        );
      } else if (status.isPermanentlyDenied) {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.permanentlyDenied,
            cameraGranted: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PermissionRequestStatus.denied,
            cameraGranted: false,
            message: 'Camera access is required for AR Navigation.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionRequestStatus.denied,
          message: 'An error occurred while requesting camera access.',
        ),
      );
    }
  }

  void _onCameraPermissionDenied(
    CameraPermissionDenied event,
    Emitter<PermissionState> emit,
  ) {
    emit(
      state.copyWith(
        status: PermissionRequestStatus.denied,
        message: 'Camera access is required for AR Navigation.',
      ),
    );
  }

  Future<void> _onRequestNotification(
    RequestNotificationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PermissionRequestStatus.loading,
        currentPermissionType: Permission.notification,
      ),
    );

    try {
      final status = await requestPermissionUseCase(Permission.notification);
      emit(
        state.copyWith(
          status: PermissionRequestStatus.navigateNext,
          notificationGranted: status.isGranted,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionRequestStatus.navigateNext,
          notificationGranted: false,
        ),
      );
    }
  }

  void _onSkipNotification(
    SkipNotificationPermission event,
    Emitter<PermissionState> emit,
  ) {
    emit(state.copyWith(status: PermissionRequestStatus.navigateNext));
  }

  void _onUpdatePageIndex(
    UpdatePageIndex event,
    Emitter<PermissionState> emit,
  ) {
    emit(
      state.copyWith(
        currentPageIndex: event.index,
        status: PermissionRequestStatus.initial,
      ),
    );
  }
}

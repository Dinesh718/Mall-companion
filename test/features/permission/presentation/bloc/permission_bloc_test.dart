import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visitor_mall/features/permission/domain/repositories/permission_repository.dart';
import 'package:visitor_mall/features/permission/domain/usecases/request_permission_usecase.dart';
import 'package:visitor_mall/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:visitor_mall/features/permission/presentation/bloc/permission_event.dart';
import 'package:visitor_mall/features/permission/presentation/bloc/permission_state.dart';

class MockPermissionRepository implements PermissionRepository {
  bool firstLaunch = true;
  PermissionStatus locationStatus = PermissionStatus.denied;
  PermissionStatus cameraStatus = PermissionStatus.denied;
  PermissionStatus notificationStatus = PermissionStatus.denied;

  @override
  Future<bool> isFirstLaunch() async => firstLaunch;

  @override
  Future<void> setFirstLaunchCompleted() async {
    firstLaunch = false;
  }

  @override
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    if (permission == Permission.location) return locationStatus;
    if (permission == Permission.camera) return cameraStatus;
    if (permission == Permission.notification) return notificationStatus;
    return PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    if (permission == Permission.location) return locationStatus;
    if (permission == Permission.camera) return cameraStatus;
    if (permission == Permission.notification) return notificationStatus;
    return PermissionStatus.denied;
  }

  @override
  Future<bool> areRequiredPermissionsGranted() async {
    return locationStatus.isGranted && cameraStatus.isGranted;
  }
}

void main() {
  late MockPermissionRepository mockRepository;
  late RequestPermissionUseCase requestPermissionUseCase;
  late PermissionBloc bloc;

  setUp(() {
    mockRepository = MockPermissionRepository();
    requestPermissionUseCase = RequestPermissionUseCase(mockRepository);
  });

  test('initial state is correct', () {
    bloc = PermissionBloc(requestPermissionUseCase: requestPermissionUseCase);
    expect(bloc.state.currentPageIndex, 0);
    expect(bloc.state.status, PermissionRequestStatus.initial);
    expect(bloc.state.locationGranted, false);
    expect(bloc.state.cameraGranted, false);
  });

  test(
    'CheckPermissionsStatus advances slide index when permissions are already granted',
    () async {
      mockRepository.locationStatus = PermissionStatus.granted;
      mockRepository.cameraStatus = PermissionStatus.granted;

      bloc = PermissionBloc(requestPermissionUseCase: requestPermissionUseCase);

      // Wait for the constructor event stream to process
      await Future.delayed(Duration.zero);

      expect(bloc.state.locationGranted, true);
      expect(bloc.state.cameraGranted, true);
      expect(bloc.state.currentPageIndex, 2); // Starts at Notification slide
    },
  );

  test('RequestLocationPermission granted advances index', () async {
    mockRepository.locationStatus = PermissionStatus.granted;
    bloc = PermissionBloc(requestPermissionUseCase: requestPermissionUseCase);

    // Clear initial constructor event
    await Future.delayed(Duration.zero);

    bloc.add(const RequestLocationPermission());
    await Future.delayed(Duration.zero);

    expect(bloc.state.locationGranted, true);
    expect(bloc.state.currentPageIndex, 1); // Advances to Camera
    expect(bloc.state.status, PermissionRequestStatus.granted);
  });
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/repositories/position_repository.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'package:visitor_mall/features/navigation/domain/entities/navigation_lifecycle_entity.dart';
import 'package:visitor_mall/features/navigation/domain/services/navigation_state_machine.dart';
import 'package:visitor_mall/features/navigation/domain/entities/active_position_source_entity.dart';
import 'package:visitor_mall/features/positioning/domain/repositories/qr_position_repository.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/data/maps/ground_floor.json' ||
        key == 'assets/data/maps/first_floor.json') {
      final file = File(key);
      final bytes = await file.readAsBytes();
      return ByteData.sublistView(bytes);
    }
    throw ArgumentError('Asset not found: $key');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/data/maps/ground_floor.json' ||
        key == 'assets/data/maps/first_floor.json') {
      final file = File(key);
      return file.readAsString();
    }
    throw ArgumentError('Asset not found: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NavigationStateMachine Pure Unit Tests', () {
    test('Valid transition: idle -> previewing', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.idle,
      );
      stateMachine.startPreview();
      expect(stateMachine.currentState, NavigationLifecycleState.previewing);
    });

    test('Valid transition: previewing -> navigating', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.previewing,
      );
      stateMachine.startNavigation();
      expect(stateMachine.currentState, NavigationLifecycleState.navigating);
    });

    test('Valid transition: navigating -> arrived', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.navigating,
      );
      stateMachine.arrive();
      expect(stateMachine.currentState, NavigationLifecycleState.arrived);
    });

    test('Valid transition: arrived -> completed', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.arrived,
      );
      stateMachine.complete();
      expect(stateMachine.currentState, NavigationLifecycleState.completed);
    });

    test('Invalid transition: idle -> arrived throws StateError', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.idle,
      );
      expect(() => stateMachine.arrive(), throwsA(isA<StateError>()));
    });

    test('Invalid transition: completed -> navigating throws StateError', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.completed,
      );
      expect(() => stateMachine.startNavigation(), throwsA(isA<StateError>()));
    });

    test('Invalid transition: cancelled -> arrived throws StateError', () {
      final stateMachine = NavigationStateMachine(
        initialState: NavigationLifecycleState.cancelled,
      );
      expect(() => stateMachine.arrive(), throwsA(isA<StateError>()));
    });
  });

  group('MapBloc Navigation Lifecycle Integration Tests', () {
    late DummyMapRepository repository;
    late MapBloc mapBloc;
    late FakePositionRepository positionRepo;
    late FakeQrPositionRepository qrRepo;

    setUp(() async {
      final datasource = LocalMapDataSourceImpl(assetBundle: TestAssetBundle());
      repository = DummyMapRepository(localDataSource: datasource);
      positionRepo = FakePositionRepository();
      qrRepo = FakeQrPositionRepository();
      mapBloc = MapBloc(
        mapRepository: repository,
        positionRepository: positionRepo,
        qrPositionRepository: qrRepo,
      );
    });

    tearDown(() {
      mapBloc.close();
    });

    test('StartNavigation updates lifecycle state to navigating', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 1. Calculate Route (Idle -> Previewing)
      mapBloc.add(const CalculateRoute(startNodeId: 'E026', endNodeId: 'E112'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.previewing,
          ),
        ),
      );

      // 2. Start Navigation (Previewing -> Navigating)
      mapBloc.add(const StartNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.navigating,
          ),
        ),
      );
    });

    test(
      'CompleteFloorTransition updates state to waitingForFloorTransition and back to navigating/arrived',
      () async {
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // Start navigation
        mapBloc.add(
          const CalculateRoute(startNodeId: 'E026', endNodeId: 'E112'),
        );
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.activeRoute,
              'activeRoute',
              isNotNull,
            ),
          ),
        );

        mapBloc.add(const StartNavigation());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationLifecycleState,
              'navigationLifecycleState',
              NavigationLifecycleState.navigating,
            ),
          ),
        );

        // Advance to connector
        mapBloc.add(const AdvanceToNextSegment());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession?.navigationStatus,
              'navigationStatus',
              NavigationStatus.waitingForConnector,
            ),
          ),
        );

        // 1. Trigger CompleteFloorTransition -> transitioningFloor
        mapBloc.add(const CompleteFloorTransition());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationLifecycleState,
              'navigationLifecycleState',
              NavigationLifecycleState.waitingForFloorTransition,
            ),
          ),
        );

        // 2. Complete Floor Transition again -> navigating
        mapBloc.add(const CompleteFloorTransition());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationLifecycleState,
              'navigationLifecycleState',
              NavigationLifecycleState.navigating,
            ),
          ),
        );
      },
    );

    test('CancelNavigation updates lifecycle state to cancelled', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      mapBloc.add(const CalculateRoute(startNodeId: 'E026', endNodeId: 'E112'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.activeRoute,
            'activeRoute',
            isNotNull,
          ),
        ),
      );

      mapBloc.add(const StartNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.navigating,
          ),
        ),
      );

      // Cancel navigation -> cancelled
      mapBloc.add(const CancelNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.cancelled,
          ),
        ),
      );
    });

    test('NavigationCompleted updates lifecycle state to completed', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Calculate route
      mapBloc.add(const CalculateRoute(startNodeId: 'E026', endNodeId: 'E112'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.activeRoute,
            'activeRoute',
            isNotNull,
          ),
        ),
      );

      // Start navigation
      mapBloc.add(const StartNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.navigating,
          ),
        ),
      );

      // Advance to connector
      mapBloc.add(const AdvanceToNextSegment());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.navigationStatus,
            'navigationStatus',
            NavigationStatus.waitingForConnector,
          ),
        ),
      );

      // Complete transitions to get to First Floor
      mapBloc.add(const CompleteFloorTransition()); // -> transitioningFloor
      mapBloc.add(
        const CompleteFloorTransition(),
      ); // -> navigating (First Floor)
      mapBloc.add(
        const CompleteFloorTransition(),
      ); // -> navigating (First Floor)
      mapBloc.add(const CompleteFloorTransition()); // -> arrived

      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.arrived,
          ),
        ),
      );

      // Dispatch NavigationCompleted -> completed
      mapBloc.add(const NavigationCompleted());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.completed,
          ),
        ),
      );
    });

    test(
      'Starting Simulation activates Simulation source on MapBloc state',
      () async {
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        mapBloc.add(const StartPositioning());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.activePositionSource,
              'activePositionSource',
              PositionSourceType.simulation,
            ),
          ),
        );
      },
    );

    test('Scanning QR activates QR source on MapBloc state', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      final qrPosition = IndoorPositionEntity(
        id: 'qr_pos_test',
        floorId: 'ground_floor',
        x: 100.0,
        y: 200.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.qr,
      );

      qrRepo.positionToReturn = qrPosition;

      mapBloc.add(const ScanQrPositionRequested('QR_123'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.activePositionSource,
            'activePositionSource',
            PositionSourceType.qr,
          ),
        ),
      );
    });

    test('DestinationSwitchRequested replaces destination and regenerates route from current user position', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));
      final loadState = mapBloc.state as MapLoaded;

      final shop1 = loadState.mapEntity.floors.first.shops.firstWhere(
        (s) => s.entranceNodeIds.isNotEmpty && s.id != 'corridor',
      );
      final shop2 = loadState.mapEntity.floors.first.shops.firstWhere(
        (s) => s.entranceNodeIds.isNotEmpty && s.id != shop1.id && s.id != 'corridor',
      );

      mapBloc.add(CalculateRoute(
        startNodeId: shop1.entranceNodeIds.first,
        endNodeId: shop2.entranceNodeIds.first,
      ));
      await expectLater(
        mapBloc.stream,
        emitsThrough(isA<MapLoaded>().having((s) => s.activeRoute, 'activeRoute', isNotNull)),
      );

      mapBloc.add(const StartNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationLifecycleState,
            'navigationLifecycleState',
            NavigationLifecycleState.navigating,
          ),
        ),
      );
      final navState = mapBloc.state as MapLoaded;

      expect(navState.navigationSession!.destinationShopId, shop2.id);

      final startNode = navState.activeRoute!.completeRoute.first;
      final userPos = IndoorPositionEntity(
        id: 'current_pos',
        floorId: startNode.floorId,
        x: startNode.x,
        y: startNode.y,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );
      mapBloc.add(UpdateUserPosition(userPos));
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      mapBloc.add(DestinationSwitchRequested(shop1.id));

      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.destinationShopId,
            'destinationShopId',
            shop1.id,
          ),
        ),
      );
      final switchedState = mapBloc.state as MapLoaded;

      expect(switchedState.activeRoute!.completeRoute.first.floorId, 'ground_floor');
      expect(switchedState.navigationLifecycleState, NavigationLifecycleState.navigating);
      expect(switchedState.navigationSession!.destinationShopId, shop1.id);
    });
  });
}

class FakePositionRepository implements PositionRepository {
  final StreamController<IndoorPositionEntity> _controller =
      StreamController<IndoorPositionEntity>.broadcast();

  bool isStarted = false;
  bool isStopped = false;
  List<IndoorPositionEntity> loadedPaths = [];

  @override
  Stream<IndoorPositionEntity> get positionStream => _controller.stream;

  @override
  void startPositioning() {
    isStarted = true;
    isStopped = false;
  }

  @override
  void stopPositioning() {
    isStopped = true;
    isStarted = false;
  }

  @override
  void resetPositioning() {
    isStarted = false;
    isStopped = false;
    loadedPaths.clear();
  }

  @override
  void loadSimulationPath(
    List<Map<String, double>> path, {
    required String floorId,
  }) {}

  @override
  void loadPositionPath(List<IndoorPositionEntity> positions) {
    loadedPaths = positions;
  }

  void emitPosition(IndoorPositionEntity position) {
    _controller.add(position);
  }

  void dispose() {
    _controller.close();
  }
}

class FakeQrPositionRepository implements QrPositionRepository {
  IndoorPositionEntity? positionToReturn;

  @override
  Future<IndoorPositionEntity?> getPositionByQrId(String qrId) async {
    return positionToReturn;
  }
}

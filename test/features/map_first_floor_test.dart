import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/services/pathfinding_service.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'package:visitor_mall/features/map/presentation/widgets/map_interaction_layer.dart';

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

  late DummyMapRepository repository;
  late MapBloc mapBloc;
  late List<ShopEntity> firstFloorShops;

  setUp(() async {
    final datasource = LocalMapDataSourceImpl(assetBundle: TestAssetBundle());
    repository = DummyMapRepository(localDataSource: datasource);
    mapBloc = MapBloc(mapRepository: repository);
    final mapData = await repository.getMapData();
    firstFloorShops = mapData.floors[1].shops;
  });

  tearDown(() {
    mapBloc.close();
  });

  group('First Floor Integration and Selector Tests', () {
    test(
      'LocalMapDataSource returns both Ground Floor and First Floor',
      () async {
        final mapData = await repository.getMapData();
        expect(mapData.floors.length, 2);
        expect(mapData.floors[0].id, 'ground_floor');
        expect(mapData.floors[1].id, 'first_floor');
        expect(mapData.floors[1].svgPath, 'assets/svg/maps/first_floor.svg');

        // Verify registered geometries (F108-F115)
        final firstFloorShops = mapData.floors[1].shops;
        expect(
          firstFloorShops.length,
          17,
        ); // 13 shops + 2 corridors + 1 escalator + 1 lift

        final shopIds = firstFloorShops.map((s) => s.id).toList();
        for (int i = 108; i <= 120; i++) {
          expect(shopIds.contains('F$i'), isTrue);
        }
        expect(shopIds.contains('F_corridor_1'), isTrue);
        expect(shopIds.contains('F_corridor_2'), isTrue);
        expect(shopIds.contains('F_escalator'), isTrue);
        expect(shopIds.contains('lift_2'), isTrue);
      },
    );

    test(
      'MapBloc handles SelectFloor and updates currentFloor state',
      () async {
        // 1. Initial load
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        final initialLoadedState = mapBloc.state as MapLoaded;
        expect(initialLoadedState.currentFloor.id, 'ground_floor');

        // 2. Select First Floor
        mapBloc.add(const SelectFloor('first_floor'));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.currentFloor.id,
              'currentFloor.id',
              'first_floor',
            ),
          ),
        );

        final finalState = mapBloc.state as MapLoaded;
        expect(finalState.currentFloor.id, 'first_floor');
        expect(
          finalState.currentFloor.svgPath,
          'assets/svg/maps/first_floor.svg',
        );
      },
    );

    test(
      'Selecting First Floor shop auto-switches active floor in MapBloc',
      () async {
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        final initialLoadedState = mapBloc.state as MapLoaded;
        expect(initialLoadedState.currentFloor.id, 'ground_floor');

        // Select first floor shop F108
        mapBloc.add(const SelectShop('F108'));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>()
                .having(
                  (s) => s.currentFloor.id,
                  'currentFloor.id',
                  'first_floor',
                )
                .having((s) => s.selectedShopId, 'selectedShopId', 'F108'),
          ),
        );
      },
    );

    test(
      'Search query for First Floor shops filters out corridors/escalators',
      () async {
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // Search for F108 (First Floor Retail Shop)
        mapBloc.add(const SearchShops('F108'));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.searchResults?.first.id,
              'searchResults.first.id',
              'F108',
            ),
          ),
        );

        // Search for Corridor/Escalator keywords - must return empty/filtered results
        mapBloc.add(const SearchShops('Corridor'));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.searchResults,
              'searchResults',
              isEmpty,
            ),
          ),
        );
      },
    );

    testWidgets('MapInteractionLayer ignores taps on Corridors and Escalators', (
      tester,
    ) async {
      // Set physical size to fit within coordinates of first floor geometries
      tester.view.physicalSize = const Size(1600.0, 900.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapBloc>.value(
            value: mapBloc,
            child: Scaffold(
              body: MapInteractionLayer(
                shops: firstFloorShops,
                width: 1536.0,
                height: 838.0,
              ),
            ),
          ),
        ),
      );

      // F_corridor_1 has geometry Rect(911, 378, 340, 40)
      // Tap at center of F_corridor_1: x = 911 + 170 = 1081, y = 378 + 20 = 398
      await tester.tapAt(const Offset(1081.0, 398.0));
      await tester.pump();

      expect(mapBloc.state, isA<MapInitial>()); // No event processed

      // F108 has geometry Rect(1175, 276, 61, 76)
      // Tap at center of F108: x = 1175 + 30 = 1205, y = 276 + 38 = 314
      await tester.tapAt(const Offset(1205.0, 314.0));
      await tester.pump();
    });

    test('vertical connectors for Ground and First floors are correctly registered and linked', () async {
      final mapData = await repository.getMapData();
      final groundFloor = mapData.floors[0];
      final firstFloor = mapData.floors[1];

      // Verify Ground Floor Connector
      expect(groundFloor.connectors, isNotEmpty);
      final gEscalator = groundFloor.connectors.firstWhere((c) => c.id == 'escalator_1_g');
      expect(gEscalator.floorId, 'ground_floor');
      expect(gEscalator.navigationNodeId, 'H009');
      expect(gEscalator.connectedConnectorId, 'escalator_1_f');
      expect(gEscalator.connectorType, 'escalator');
      expect(gEscalator.accessible, isTrue);
      expect(gEscalator.metadata?['destinationFloorId'], 'first_floor');
      expect(gEscalator.metadata?['destinationConnectorId'], 'escalator_1_f');

      // Verify First Floor Connector
      expect(firstFloor.connectors, isNotEmpty);
      final fEscalator = firstFloor.connectors.firstWhere((c) => c.id == 'escalator_1_f');
      expect(fEscalator.floorId, 'first_floor');
      expect(fEscalator.navigationNodeId, 'H109');
      expect(fEscalator.connectedConnectorId, 'escalator_1_g');
      expect(fEscalator.connectorType, 'escalator');
      expect(fEscalator.accessible, isTrue);
      expect(fEscalator.metadata?['destinationFloorId'], 'ground_floor');
      expect(fEscalator.metadata?['destinationConnectorId'], 'escalator_1_g');

      // Verify node positions and existence
      final gNode = groundFloor.navigationGraph.nodes.firstWhere((n) => n.id == 'H009');
      expect(gNode.x, 1300.0);
      expect(gNode.y, 440.0);

      final fNode = firstFloor.navigationGraph.nodes.firstWhere((n) => n.id == 'H109');
      expect(fNode.x, 1325.5);
      expect(fNode.y, 407.0);
    });

    test('First Floor pathfinding computes valid paths internally', () async {
      final mapData = await repository.getMapData();
      final firstFloor = mapData.floors[1];

      // Route from shop F117 (leftmost) to F120 (rightmost) on First Floor
      // F117 connects to E117 -> H101
      // F120 connects to E120 -> H107
      final path = PathfindingService.findPath(
        graph: firstFloor.navigationGraph,
        startNodeId: 'E117',
        endNodeId: 'E120',
      );

      expect(path, isNotEmpty);
      expect(path.first.id, 'E117');
      expect(path.last.id, 'E120');

      // Verify the sequence of nodes along the centerline corridor and escalator node
      final nodeIds = path.map((n) => n.id).toList();
      expect(nodeIds, containsAll([
        'E117', 'H101', 'H102', 'H103', 'H104', 'H105', 'H109', 'H106', 'H107', 'E120'
      ]));

      // Verify path between F114 and H109 (escalator node)
      // F114 connects to E114 -> H103
      final escalatorPath = PathfindingService.findPath(
        graph: firstFloor.navigationGraph,
        startNodeId: 'E114',
        endNodeId: 'H109',
      );
      expect(escalatorPath, isNotEmpty);
      expect(escalatorPath.first.id, 'E114');
      expect(escalatorPath.last.id, 'H109');
    });

    test('cross-floor route generation between Ground Floor shop and First Floor shop produces correct 3 segments', () async {
      // 1. Load map and calculate route in MapBloc
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // S026 (Grand Hypermarket) has entrance E026 on Ground Floor
      // F112 (Shop F112) has entrance E112 on First Floor
      // Escalator H009 connects to H109
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

      final state = mapBloc.state as MapLoaded;
      final route = state.activeRoute!;

      // Verify segmentation length
      expect(route.segments.length, 3);

      // Verify Ground Floor RouteSegment
      final groundSeg = route.segments[0];
      expect(groundSeg.floorId, 'ground_floor');
      expect(groundSeg.nodes.first.id, 'E026');
      expect(groundSeg.nodes.last.id, 'H009');

      // Verify Connector Transition Segment
      final transitionSeg = route.segments[1];
      expect(transitionSeg.floorId, 'transition');
      expect(transitionSeg.nodes.map((n) => n.id).toList(), ['H009', 'H109']);

      // Verify First Floor RouteSegment
      final firstSeg = route.segments[2];
      expect(firstSeg.floorId, 'first_floor');
      expect(firstSeg.nodes.first.id, 'H109');
      expect(firstSeg.nodes.last.id, 'E112');
    });

    test('automatic floor transition triggers when position stream crosses connector and changes floorId', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Start navigation from Ground Hypermarket E026 to First Floor Shop F117 (entrance E117)
      mapBloc.add(const CalculateRoute(startNodeId: 'E026', endNodeId: 'E117'));
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

      var state = mapBloc.state as MapLoaded;
      expect(state.currentFloor.id, 'ground_floor');
      expect(state.navigationSession?.currentSegmentIndex, 0);

      // Emit a series of user positions
      // 1. Initial position at E026 (Ground Floor)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_1',
        floorId: 'ground_floor',
        x: 857.0, // E026 x
        y: 587.0,  // E026 y
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.latestPosition?.id,
            'latestPosition.id',
            'pos_1',
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      expect(state.currentFloor.id, 'ground_floor');
      expect(state.navigationSession?.currentSegmentIndex, 0);

      // 2. Position close to lift node L002 (Ground Connector)
      // Lift L002 is at (850.5, 272.5)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_2',
        floorId: 'ground_floor',
        x: 850.5,
        y: 272.5,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.navigationStatus,
            'navigationStatus',
            NavigationStatus.transitioningFloor,
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      expect(state.currentFloor.id, 'ground_floor');
      // Segment index should have advanced to transition segment (index 1)
      expect(state.navigationSession?.currentSegmentIndex, 1);
      expect(state.navigationSession?.currentFloorId, 'transition');

      // 3. Position steps onto First Floor (floorId switches to 'first_floor')
      // Node L102 is at (872.5, 244.5)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_3',
        floorId: 'first_floor',
        x: 872.5,
        y: 244.5,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.currentFloor.id,
            'currentFloor.id',
            'first_floor',
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      // Visible floor automatically switched!
      expect(state.currentFloor.id, 'first_floor');
      // Segment index advanced to first floor segment (index 2)
      expect(state.navigationSession?.currentSegmentIndex, 2);
      expect(state.navigationSession?.navigationStatus, NavigationStatus.navigating);

      // 4. Progress along first floor to E117 (957.5, 460.0)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_4',
        floorId: 'first_floor',
        x: 957.5,
        y: 460.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.navigationStatus,
            'navigationStatus',
            NavigationStatus.arrived,
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      expect(state.navigationSession?.navigationStatus, NavigationStatus.arrived);
    });

    test('manual floor selection during active navigation preserves session and route', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Start navigation
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

      var state = mapBloc.state as MapLoaded;
      expect(state.currentFloor.id, 'ground_floor');
      expect(state.activeRoute, isNotNull);
      expect(state.navigationSession, isNotNull);

      // Manually select First Floor
      mapBloc.add(const SelectFloor('first_floor'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.currentFloor.id,
            'currentFloor.id',
            'first_floor',
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      // Floor switched manually to first floor
      expect(state.currentFloor.id, 'first_floor');
      // Navigation session and active route are preserved!
      expect(state.activeRoute, isNotNull);
      expect(state.navigationSession, isNotNull);
      expect(state.navigationSession?.currentSegmentIndex, 0); // Still starting segment
    });

    test('cross-floor route generation from First Floor shop to Ground Floor shop produces correct segments in reverse', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Calculate route from F112 (E112) on First Floor to S026 (E026) on Ground Floor
      mapBloc.add(const CalculateRoute(startNodeId: 'E112', endNodeId: 'E026'));
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

      final state = mapBloc.state as MapLoaded;
      final route = state.activeRoute!;

      // Verify segments length
      expect(route.segments.length, 3);

      // Verify First Floor Segment is index 0
      final firstSeg = route.segments[0];
      expect(firstSeg.floorId, 'first_floor');
      expect(firstSeg.nodes.first.id, 'E112');
      expect(firstSeg.nodes.last.id, 'H109');

      // Verify Connector Transition Segment is index 1
      final transitionSeg = route.segments[1];
      expect(transitionSeg.floorId, 'transition');
      expect(transitionSeg.nodes.map((n) => n.id).toList(), ['H109', 'H009']);

      // Verify Ground Floor Segment is index 2
      final groundSeg = route.segments[2];
      expect(groundSeg.floorId, 'ground_floor');
      expect(groundSeg.nodes.first.id, 'H009');
      expect(groundSeg.nodes.last.id, 'E026');
    });

    test('navigation cancellation during floor transition successfully clears session', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Start navigation
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

      // Advance user position to the escalator connector H009
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_connector',
        floorId: 'ground_floor',
        x: 1300.0,
        y: 440.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.navigationStatus,
            'navigationStatus',
            NavigationStatus.transitioningFloor,
          ),
        ),
      );

      var state = mapBloc.state as MapLoaded;
      expect(state.navigationSession?.currentSegmentIndex, 1);
      expect(state.navigationSession?.navigationStatus, NavigationStatus.transitioningFloor);

      // Cancel navigation
      mapBloc.add(const CancelNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession,
            'navigationSession',
            isNull,
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      expect(state.activeRoute, isNull);
      expect(state.navigationSession, isNull);
    });

    test('recalculate route after destination change replaces existing session seamlessly', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // Calculate initial route to First Floor Shop F112
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

      var state = mapBloc.state as MapLoaded;
      expect(state.navigationSession?.destinationShopId, 'F112');

      // Change destination to S027 (entrance E027) while session is active
      mapBloc.add(const CalculateRoute(startNodeId: 'E026', endNodeId: 'E027'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.navigationSession?.destinationShopId,
            'destinationShopId',
            'shop_027',
          ),
        ),
      );

      state = mapBloc.state as MapLoaded;
      expect(state.navigationSession?.destinationShopId, 'shop_027');
      expect(state.navigationSession?.currentSegmentIndex, 0);
      expect(state.navigationSession?.segments.length, 1); // Single floor routing is 1 segment
    });

    test('dynamic navigation origin resolves correctly from inside a Ground Floor shop', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 1. Simulate position inside Ground Floor Zara (shop_001)
      // Zara geometry: x: 80.0, y: 320.0, width: 77.0, height: 83.0 (centre point ~ x: 118.0, y: 360.0)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_zara',
        floorId: 'ground_floor',
        x: 118.0,
        y: 360.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>().having((s) => s.latestPosition, 'latestPosition', isNotNull)));

      // Calculate route - startNodeId is passed as H001, but latestPosition should override it to E001 (Zara entrance)
      mapBloc.add(const CalculateRoute(startNodeId: 'H001', endNodeId: 'E112'));
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

      final state = mapBloc.state as MapLoaded;
      expect(state.activeRoute!.completeRoute.first.id, 'E001');
    });

    test('dynamic navigation origin snaps to nearest node outside shop on First Floor', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 2. Simulate position in the first floor corridor (near H102: x: 1032.5, y: 398.0)
      mapBloc.add(UpdateUserPosition(IndoorPositionEntity(
        id: 'pos_corridor',
        floorId: 'first_floor',
        x: 1030.0,
        y: 400.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      )));
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>().having((s) => s.latestPosition, 'latestPosition', isNotNull)));

      // Calculate route - startNodeId is H001, but should override to H102
      mapBloc.add(const CalculateRoute(startNodeId: 'H001', endNodeId: 'E112'));
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

      final state = mapBloc.state as MapLoaded;
      expect(state.activeRoute!.completeRoute.first.id, 'H102');
    });
  });
}

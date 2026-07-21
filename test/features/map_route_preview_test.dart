import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/route_preview_entities.dart';
import 'package:visitor_mall/features/map/domain/services/route_preview_service.dart';
import 'package:visitor_mall/features/map/domain/services/route_camera_service.dart';
import 'package:visitor_mall/features/map/data/datasources/simulation_position_provider.dart';
import 'package:visitor_mall/features/map/data/repositories/position_repository_impl.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart';

void main() {
  group('RoutePreviewService Pure Unit Tests', () {
    final nodesGround = [
      const NavigationNodeEntity(id: 'N01', x: 100.0, y: 100.0, floorId: 'ground_floor', type: 'hallway'),
      const NavigationNodeEntity(id: 'N02', x: 300.0, y: 100.0, floorId: 'ground_floor', type: 'hallway'),
      const NavigationNodeEntity(id: 'N03', x: 300.0, y: 400.0, floorId: 'ground_floor', type: 'hallway'),
    ];

    final routeGround = NavigationRouteEntity(
      completeRoute: nodesGround,
      segments: [RouteSegmentEntity(floorId: 'ground_floor', nodes: nodesGround)],
      totalDistance: 500.0,
    );

    final groundFloor = FloorEntity(
      id: 'ground_floor',
      name: 'Ground Floor',
      svgPath: 'ground.svg',
      shops: const [
        ShopEntity(
          id: 'shop_zara',
          name: 'Zara',
          category: 'Fashion',
          description: '',
          status: 'open',
          rating: 4.8,
          offer: '',
          geometry: RectangleGeometry(x: 280, y: 380, width: 40, height: 40),
          entranceNodeIds: ['N03'],
        ),
      ],
      navigationGraph: const NavigationGraphEntity(nodes: [], edges: []),
      connectors: const [],
    );

    test('Computes accurate bounding box, distance, and walking time', () {
      final preview = RoutePreviewService.generatePreview(
        route: routeGround,
        floors: [groundFloor],
        destinationShopId: 'shop_zara',
        walkingSpeedMetersPerMin: 70.0,
      );

      expect(preview.isPreviewReady, true);
      expect(preview.bounds.minX, 100.0);
      expect(preview.bounds.maxX, 300.0);
      expect(preview.bounds.minY, 100.0);
      expect(preview.bounds.maxY, 400.0);

      expect(preview.statistics.totalDistance, 500.0);
      expect(preview.statistics.estimatedWalkingTimeMinutes, 8); // (500 / 70).ceil() = 8
      expect(preview.statistics.destinationName, 'Zara');
      expect(preview.statistics.floorSummary, 'Ground Floor');
      expect(preview.statistics.connectorCount, 0);
    });

    test('Computes cross-floor route summary and connector details correctly', () {
      final nodesFirst = [
        const NavigationNodeEntity(id: 'N10', x: 300.0, y: 400.0, floorId: 'first_floor', type: 'hallway'),
      ];

      final routeCrossFloor = NavigationRouteEntity(
        completeRoute: [...nodesGround, ...nodesFirst],
        segments: [
          RouteSegmentEntity(floorId: 'ground_floor', nodes: nodesGround),
          RouteSegmentEntity(floorId: 'transition', nodes: [nodesGround.last, nodesFirst.first]),
          RouteSegmentEntity(floorId: 'first_floor', nodes: nodesFirst),
        ],
        totalDistance: 550.0,
      );

      final firstFloor = FloorEntity(
        id: 'first_floor',
        name: 'First Floor',
        svgPath: 'first.svg',
        shops: const [],
        navigationGraph: const NavigationGraphEntity(nodes: [], edges: []),
        connectors: const [],
      );

      final groundFloorWithLift = FloorEntity(
        id: 'ground_floor',
        name: 'Ground Floor',
        svgPath: 'ground.svg',
        shops: const [],
        navigationGraph: const NavigationGraphEntity(nodes: [], edges: []),
        connectors: const [
          ConnectorEntity(
            id: 'lift_01',
            floorId: 'ground_floor',
            navigationNodeId: 'N03',
            connectorType: 'elevator',
            accessible: true,
          ),
        ],
      );

      final preview = RoutePreviewService.generatePreview(
        route: routeCrossFloor,
        floors: [groundFloorWithLift, firstFloor],
        destinationShopId: 'shop_zara',
      );

      expect(preview.statistics.floorCount, 2);
      expect(preview.statistics.floorSummary, 'Ground Floor → First Floor');
      expect(preview.statistics.connectorCount, 1);
      expect(preview.statistics.connectorNames.first, contains('ELEVATOR'));
    });
  });

  group('RouteCameraService Pure Unit Tests', () {
    test('Calculates camera center and recommended scale correctly', () {
      const bounds = RouteBoundsEntity(
        minX: 100.0,
        maxX: 500.0,
        minY: 200.0,
        maxY: 600.0,
      );

      final fit = RouteCameraService.calculateCameraFit(
        bounds: bounds,
        viewportWidth: 400.0,
        viewportHeight: 800.0,
        padding: 50.0,
      );

      expect(fit.centerX, 300.0);
      expect(fit.centerY, 400.0);
      expect(fit.recommendedScale, greaterThan(0.0));
    });
  });

  group('MapBloc Route Preview Mode Integration Tests', () {
    late MockMapRepository mockRepo;
    late SimulationPositionProvider positionProvider;
    late PositionRepositoryImpl positionRepo;
    late MapBloc mapBloc;

    const node1 = NavigationNodeEntity(id: 'N01', x: 100.0, y: 100.0, floorId: 'ground_floor', type: 'hallway');
    const node2 = NavigationNodeEntity(id: 'N02', x: 200.0, y: 100.0, floorId: 'ground_floor', type: 'hallway');

    final groundFloor = FloorEntity(
      id: 'ground_floor',
      name: 'Ground Floor',
      svgPath: '',
      shops: const [
        ShopEntity(
          id: 'shop_zara',
          name: 'Zara',
          category: 'Fashion',
          description: '',
          status: 'open',
          rating: 4.5,
          offer: '',
          geometry: RectangleGeometry(x: 180, y: 80, width: 40, height: 40),
          entranceNodeIds: ['N02'],
        ),
      ],
      navigationGraph: const NavigationGraphEntity(
        nodes: [node1, node2],
        edges: [NavigationEdgeEntity(fromNodeId: 'N01', toNodeId: 'N02', distance: 100.0)],
      ),
      connectors: const [],
    );

    final mapEntity = MapEntity(id: 'mall_1', floors: [groundFloor]);

    setUp(() {
      mockRepo = MockMapRepository(mapEntity);
      positionProvider = SimulationPositionProvider();
      positionRepo = PositionRepositoryImpl(positionProvider);

      mapBloc = MapBloc(
        mapRepository: mockRepo,
        positionRepository: positionRepo,
      );
    });

    tearDown(() {
      mapBloc.close();
      positionProvider.dispose();
    });

    test('CalculateRoute enters preview mode without starting positioning simulation', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having((s) => s.isPreviewMode, 'isPreviewMode', true),
        ),
      );

      final loadedState = mapBloc.state as MapLoaded;
      expect(loadedState.preview, isNotNull);
      expect(loadedState.preview!.statistics.destinationName, 'Zara');
      expect(loadedState.navigationSession, isNull);
      expect(loadedState.instructions, isNull);
    });

    test('StartNavigation transitions out of preview mode and starts positioning simulation', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having((s) => s.isPreviewMode, 'isPreviewMode', true),
        ),
      );

      // Now user taps START NAVIGATION on preview card
      mapBloc.add(const StartNavigation());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having((s) => s.isPreviewMode, 'isPreviewMode', false),
        ),
      );

      final loadedState = mapBloc.state as MapLoaded;
      expect(loadedState.navigationSession, isNotNull);
      expect(loadedState.instructions, isNotNull);
    });

    test('ClearRoute closes preview mode and resets route state', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having((s) => s.isPreviewMode, 'isPreviewMode', true),
        ),
      );

      // User cancels preview
      mapBloc.add(const ClearRoute());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>()
              .having((s) => s.isPreviewMode, 'isPreviewMode', false)
              .having((s) => s.activeRoute, 'activeRoute', isNull),
        ),
      );
    });
  });
}

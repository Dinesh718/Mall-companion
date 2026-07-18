import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/services/navigation_progress_service.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart'; // Reuse MockMapRepository

void main() {
  group('NavigationProgressService Pure Unit Tests', () {
    const node1 = NavigationNodeEntity(
      id: 'N01',
      x: 10.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );
    const node2 = NavigationNodeEntity(
      id: 'N02',
      x: 20.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );
    const node3 = NavigationNodeEntity(
      id: 'N03',
      x: 30.0,
      y: 10.0,
      floorId: 'g',
      type: 'hallway',
    );

    const segment = RouteSegmentEntity(
      floorId: 'g',
      nodes: [node1, node2, node3],
    );

    const route = NavigationRouteEntity(
      completeRoute: [node1, node2, node3],
      segments: [segment],
      totalDistance: 20.0,
    );

    const session = NavigationSessionEntity(
      destinationShopId: 'shop_zara',
      destinationEntranceId: 'N03',
      route: route,
      segments: [segment],
      currentSegmentIndex: 0,
      currentFloorId: 'g',
      nextConnectorId: null,
      remainingDistance: 20.0,
      estimatedWalkingDistance: 20.0,
      navigationStatus: NavigationStatus.navigating,
    );

    test('Identifies the closest route node and index correctly', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
      );

      expect(result.nearestNodeId, 'N02');
      expect(result.nearestRouteIndex, 1);
    });

    test('checkOffRoute returns false when user is close to path segments', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 15.0,
        y: 12.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isFalse);
    });

    test('checkOffRoute returns true when user deviates past threshold', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 15.0,
        y: 45.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isTrue);
    });

    test('checkOffRoute returns true when user is on a different floor', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'first_floor',
        x: 15.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final isOffRoute = NavigationProgressService.checkOffRoute(
        position: pos,
        session: session,
        threshold: 30.0,
      );

      expect(isOffRoute, isTrue);
    });

    test('Correctly computes remaining distance dynamically', () {
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
      );

      // Distance from user(18) to node2(20) is 2.0. Plus distance from node2(20) to node3(30) is 10.0.
      // Total remaining distance should be 12.0
      expect(result.remainingDistance, closeTo(12.0, 0.001));
    });

    test('Checks next node reached based on configurable threshold', () {
      // User is at (18, 10), node2 is at (20, 10). Distance is 2.0.
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      // 1. With threshold of 5.0 (greater than 2.0), hasReachedNextNode should be true
      final result1 = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
        threshold: 5.0,
      );
      expect(result1.hasReachedNextNode, isTrue);

      // 2. With threshold of 1.0 (smaller than 2.0), hasReachedNextNode should be false
      final result2 = NavigationProgressService.evaluateProgress(
        position: pos,
        session: session,
        threshold: 1.0,
      );
      expect(result2.hasReachedNextNode, isFalse);
    });

    test(
      'Detects destination arrival correctly when near final entrance node',
      () {
        // User is at (28, 10), node3 (destination) is at (30, 10). Distance is 2.0.
        final pos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'g',
          x: 28.0,
          y: 10.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        final result = NavigationProgressService.evaluateProgress(
          position: pos,
          session: session,
          threshold: 5.0,
        );

        expect(result.hasReachedDestination, isTrue);
      },
    );

    test('Detects connector arrival correctly when near segment connector', () {
      const connSegment = RouteSegmentEntity(
        floorId: 'g',
        nodes: [node1, node2], // node2 is connector node
      );

      const connSession = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'N03',
        route: route,
        segments: [connSegment],
        currentSegmentIndex: 0,
        currentFloorId: 'g',
        nextConnectorId: 'conn_g1',
        remainingDistance: 20.0,
        estimatedWalkingDistance: 20.0,
        navigationStatus: NavigationStatus.navigating,
      );

      // User is at (18, 10), node2 (connector node) is at (20, 10).
      final pos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'g',
        x: 18.0,
        y: 10.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final result = NavigationProgressService.evaluateProgress(
        position: pos,
        session: connSession,
        threshold: 5.0,
      );

      expect(result.hasReachedConnector, isTrue);
      expect(result.shouldAdvanceSegment, isTrue);
      expect(result.shouldBeginFloorTransition, isTrue);
    });
  });

  group('MapBloc Progression Integration Tests', () {
    late MockMapRepository mockRepo;
    late MapBloc mapBloc;

    const node1 = NavigationNodeEntity(
      id: 'N01',
      x: 100.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const node2 = NavigationNodeEntity(
      id: 'N02',
      x: 200.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );

    setUp(() {
      final groundFloor = FloorEntity(
        id: 'ground_floor',
        name: 'Ground Floor',
        svgPath: '',
        shops: const [
          ShopEntity(
            id: 'shop_001',
            name: 'Zara',
            category: 'Fashion',
            description: '',
            status: 'open',
            rating: 4.5,
            offer: '',
            geometry: RectangleGeometry(x: 0, y: 0, width: 50, height: 50),
            entranceNodeIds: ['N02'],
          ),
        ],
        navigationGraph: const NavigationGraphEntity(
          nodes: [node1, node2],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'N01',
              toNodeId: 'N02',
              distance: 100.0,
            ),
          ],
        ),
        connectors: const [],
      );

      final mapEntity = MapEntity(id: 'mall_phoenix', floors: [groundFloor]);

      mockRepo = MockMapRepository(mapEntity);
      mapBloc = MapBloc(mapRepository: mockRepo);
    });

    tearDown(() {
      mapBloc.close();
    });

    test(
      'MapBloc automatically updates remainingDistance and triggers arrived state on position updates',
      () async {
        // 1. Load Map
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Select and Calculate Route to Shop
        mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        var state = mapBloc.state as MapLoaded;
        expect(state.navigationSession!.remainingDistance, 100.0);
        expect(
          state.navigationSession!.navigationStatus,
          NavigationStatus.navigating,
        );

        // 3. User moves halfway to (150, 100). Remaining distance should decrease to ~50.0
        final midPos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'ground_floor',
          x: 150.0,
          y: 100.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        mapBloc.add(UpdateUserPosition(midPos));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession?.remainingDistance,
              'remainingDistance',
              closeTo(50.0, 1.0),
            ),
          ),
        );

        // 4. User arrives at destination entrance (198, 100) (within threshold of 15.0 to N02)
        final arrivalPos = IndoorPositionEntity(
          id: 'user_pos',
          floorId: 'ground_floor',
          x: 198.0,
          y: 100.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        );

        mapBloc.add(UpdateUserPosition(arrivalPos));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>()
                .having(
                  (s) => s.navigationSession?.navigationStatus,
                  'navigationStatus',
                  NavigationStatus.arrived,
                )
                .having(
                  (s) => s.navigationSession?.remainingDistance,
                  'remainingDistance',
                  0.0,
                ),
          ),
        );
      },
    );
  });
}

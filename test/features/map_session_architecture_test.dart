import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/data/models/navigation_session_model.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart'; // Reuse MockMapRepository

void main() {
  group('Navigation Session Architecture Tests', () {
    const startNode = NavigationNodeEntity(
      id: 'H001',
      x: 10.0,
      y: 20.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const endNode = NavigationNodeEntity(
      id: 'H002',
      x: 50.0,
      y: 20.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );

    const segment = RouteSegmentEntity(
      floorId: 'ground_floor',
      nodes: [startNode, endNode],
    );

    const route = NavigationRouteEntity(
      completeRoute: [startNode, endNode],
      segments: [segment],
      totalDistance: 40.0,
    );

    test('NavigationSessionEntity construction and properties are correct', () {
      const session = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'E001',
        route: route,
        segments: [segment],
        currentSegmentIndex: 0,
        currentFloorId: 'ground_floor',
        nextConnectorId: null,
        remainingDistance: 40.0,
        estimatedWalkingDistance: 40.0,
        navigationStatus: NavigationStatus.navigating,
      );

      expect(session.destinationShopId, 'shop_zara');
      expect(session.destinationEntranceId, 'E001');
      expect(session.route, route);
      expect(session.segments.length, 1);
      expect(session.currentSegmentIndex, 0);
      expect(session.activeSegment, segment);
      expect(session.currentFloorId, 'ground_floor');
      expect(session.nextConnectorId, isNull);
      expect(session.remainingDistance, 40.0);
      expect(session.estimatedWalkingDistance, 40.0);
      expect(session.navigationStatus, NavigationStatus.navigating);
    });

    test('NavigationStatus values match architectural expectations', () {
      expect(NavigationStatus.idle.name, 'idle');
      expect(NavigationStatus.navigating.name, 'navigating');
      expect(NavigationStatus.arrived.name, 'arrived');
      expect(NavigationStatus.cancelled.name, 'cancelled');
    });

    test('NavigationSessionModel supports copyWith and serialization', () {
      const session = NavigationSessionModel(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'E001',
        route: route,
        segments: [segment],
        currentSegmentIndex: 0,
        currentFloorId: 'ground_floor',
        nextConnectorId: null,
        remainingDistance: 40.0,
        estimatedWalkingDistance: 40.0,
        navigationStatus: NavigationStatus.navigating,
      );

      final updated = session.copyWith(
        navigationStatus: NavigationStatus.arrived,
        currentSegmentIndex: 1,
      );

      expect(updated.navigationStatus, NavigationStatus.arrived);
      expect(updated.currentSegmentIndex, 1);

      // JSON Serialization verification
      final json = updated.toJson();
      expect(json['destinationShopId'], 'shop_zara');
      expect(json['navigationStatus'], 'arrived');

      final deserialized = NavigationSessionModel.fromJson(json);
      expect(deserialized.destinationShopId, 'shop_zara');
      expect(deserialized.navigationStatus, NavigationStatus.arrived);
    });

    test('activeSegment returns null when index is out of bounds', () {
      const session = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'E001',
        route: route,
        segments: [segment],
        currentSegmentIndex: 5, // Out of bounds
        currentFloorId: 'ground_floor',
        nextConnectorId: null,
        remainingDistance: 40.0,
        estimatedWalkingDistance: 40.0,
        navigationStatus: NavigationStatus.navigating,
      );

      expect(session.activeSegment, isNull);
    });

    test('Equality comparisons verify identical values in session entity', () {
      const session1 = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'E001',
        route: route,
        segments: [segment],
        currentSegmentIndex: 0,
        currentFloorId: 'ground_floor',
        nextConnectorId: null,
        remainingDistance: 40.0,
        estimatedWalkingDistance: 40.0,
        navigationStatus: NavigationStatus.navigating,
      );

      const session2 = NavigationSessionEntity(
        destinationShopId: 'shop_zara',
        destinationEntranceId: 'E001',
        route: route,
        segments: [segment],
        currentSegmentIndex: 0,
        currentFloorId: 'ground_floor',
        nextConnectorId: null,
        remainingDistance: 40.0,
        estimatedWalkingDistance: 40.0,
        navigationStatus: NavigationStatus.navigating,
      );

      expect(session1, equals(session2));
    });
  });

  group('MapBloc NavigationSession Integration Tests', () {
    late MockMapRepository mockRepo;
    late MapBloc mapBloc;

    // Define dummy nodes
    const nodeH001 = NavigationNodeEntity(
      id: 'H001',
      x: 100.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const nodeH002 = NavigationNodeEntity(
      id: 'H002',
      x: 200.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const nodeH101 = NavigationNodeEntity(
      id: 'H101',
      x: 100.0,
      y: 100.0,
      floorId: 'first_floor',
      type: 'hallway',
    );
    const nodeH102 = NavigationNodeEntity(
      id: 'H102',
      x: 200.0,
      y: 100.0,
      floorId: 'first_floor',
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
            entranceNodeIds: ['H101'],
          ),
        ],
        navigationGraph: const NavigationGraphEntity(
          nodes: [nodeH001, nodeH002],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'H001',
              toNodeId: 'H002',
              distance: 100.0,
            ),
          ],
        ),
        connectors: const [
          ConnectorEntity(
            id: 'conn_g1',
            floorId: 'ground_floor',
            navigationNodeId: 'H002',
            connectedConnectorId: 'conn_f1',
            connectorType: 'escalator',
            accessible: true,
          ),
        ],
      );

      final firstFloor = FloorEntity(
        id: 'first_floor',
        name: 'First Floor',
        svgPath: '',
        shops: const [],
        navigationGraph: const NavigationGraphEntity(
          nodes: [nodeH101, nodeH102],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'H101',
              toNodeId: 'H102',
              distance: 100.0,
            ),
          ],
        ),
        connectors: const [
          ConnectorEntity(
            id: 'conn_f1',
            floorId: 'first_floor',
            navigationNodeId: 'H102',
            connectedConnectorId: 'conn_g1',
            connectorType: 'escalator',
            accessible: true,
          ),
        ],
      );

      final mapEntity = MapEntity(
        id: 'mall_phoenix',
        floors: [groundFloor, firstFloor],
      );

      mockRepo = MockMapRepository(mapEntity);
      mapBloc = MapBloc(mapRepository: mockRepo);
    });

    tearDown(() {
      mapBloc.close();
    });

    test(
      'MapBloc manages multi-floor navigation segment progression correctly',
      () async {
        // 1. Load Map
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Calculate route to the first floor shop
        mapBloc.add(
          const CalculateRoute(startNodeId: 'H001', endNodeId: 'H101'),
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
              (s) => s.navigationSession,
              'navigationSession',
              isNotNull,
            ),
          ),
        );

        var state = mapBloc.state as MapLoaded;
        var session = state.navigationSession!;
        expect(session.destinationShopId, 'shop_001');
        expect(session.destinationEntranceId, 'H101');
        expect(session.navigationStatus, NavigationStatus.navigating);
        expect(session.currentSegmentIndex, 0);
        expect(session.currentFloorId, 'ground_floor');
        expect(session.nextConnectorId, 'conn_g1');

        // 3. Advance to connector (reached escalator node H002)
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

        state = mapBloc.state as MapLoaded;
        session = state.navigationSession!;
        expect(session.currentSegmentIndex, 0);
        expect(session.currentFloorId, 'ground_floor');

        // 4. Start Floor Transition (step on escalator)
        mapBloc.add(const CompleteFloorTransition());
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

        // 5. Complete Floor Transition (onto transition segment)
        mapBloc.add(const CompleteFloorTransition());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession?.navigationStatus,
              'navigationStatus',
              NavigationStatus.navigating,
            ),
          ),
        );

        // 5b. Complete transition again to step off transition segment onto First Floor segment
        mapBloc.add(const CompleteFloorTransition());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.navigationSession?.navigationStatus,
              'navigationStatus',
              NavigationStatus.navigating,
            ),
          ),
        );

        state = mapBloc.state as MapLoaded;
        session = state.navigationSession!;
        expect(session.currentSegmentIndex, 2);
        expect(session.currentFloorId, 'first_floor');
        expect(session.nextConnectorId, isNull);
        expect(state.currentFloor.id, 'first_floor');

        // 6. Complete transition again on last segment to trigger arrival
        mapBloc.add(const CompleteFloorTransition());
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
        session = state.navigationSession!;
        expect(session.remainingDistance, 0.0);

        // 7. Cancel navigation clears session
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
      },
    );
  });
}

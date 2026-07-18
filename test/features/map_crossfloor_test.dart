import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/repositories/map_repository.dart';
import 'package:visitor_mall/features/map/domain/services/pathfinding_service.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';

void main() {
  group('Cross-Floor Pathfinding Service Tests', () {
    // Define shared nodes for Floor 1 (Ground)
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
    const nodeH003 = NavigationNodeEntity(
      id: 'H003',
      x: 300.0,
      y: 100.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );

    // Define shared nodes for Floor 2 (First)
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
    const nodeH103 = NavigationNodeEntity(
      id: 'H103',
      x: 300.0,
      y: 100.0,
      floorId: 'first_floor',
      type: 'hallway',
    );

    late FloorEntity groundFloor;
    late FloorEntity firstFloor;
    late List<FloorEntity> floors;

    setUp(() {
      groundFloor = FloorEntity(
        id: 'ground_floor',
        name: 'Ground Floor',
        svgPath: '',
        shops: const [],
        navigationGraph: const NavigationGraphEntity(
          nodes: [nodeH001, nodeH002, nodeH003],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'H001',
              toNodeId: 'H002',
              distance: 100.0,
            ),
            NavigationEdgeEntity(
              fromNodeId: 'H002',
              toNodeId: 'H003',
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
          ConnectorEntity(
            id: 'conn_g2',
            floorId: 'ground_floor',
            navigationNodeId: 'H003',
            connectedConnectorId: 'conn_f2',
            connectorType: 'elevator',
            accessible: true,
          ),
        ],
      );

      firstFloor = FloorEntity(
        id: 'first_floor',
        name: 'First Floor',
        svgPath: '',
        shops: const [],
        navigationGraph: const NavigationGraphEntity(
          nodes: [nodeH101, nodeH102, nodeH103],
          edges: [
            NavigationEdgeEntity(
              fromNodeId: 'H101',
              toNodeId: 'H102',
              distance: 100.0,
            ),
            NavigationEdgeEntity(
              fromNodeId: 'H102',
              toNodeId: 'H103',
              distance: 50.0, // Force a specific choice by making it cheaper
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
          ConnectorEntity(
            id: 'conn_f2',
            floorId: 'first_floor',
            navigationNodeId: 'H103',
            connectedConnectorId: 'conn_g2',
            connectorType: 'elevator',
            accessible: true,
          ),
        ],
      );

      floors = [groundFloor, firstFloor];
    });

    test(
      'Same-floor routing logic remains unchanged and resolves correct paths',
      () {
        final path = PathfindingService.findPath(
          graph: groundFloor.navigationGraph,
          startNodeId: 'H001',
          endNodeId: 'H003',
          floors: floors,
        );

        expect(path.map((n) => n.id).toList(), ['H001', 'H002', 'H003']);
      },
    );

    test(
      'Ground to First floor routing routes through correct connector bridge',
      () {
        final path = PathfindingService.findPath(
          graph: groundFloor.navigationGraph,
          startNodeId: 'H001',
          endNodeId: 'H101',
          floors: floors,
        );

        expect(path.map((n) => n.id).toList(), [
          'H001',
          'H002',
          'H102',
          'H101',
        ]);
      },
    );

    test('First to Ground floor routing works symmetrically', () {
      final path = PathfindingService.findPath(
        graph: firstFloor.navigationGraph,
        startNodeId: 'H101',
        endNodeId: 'H001',
        floors: floors,
      );

      expect(path.map((n) => n.id).toList(), ['H101', 'H102', 'H002', 'H001']);
    });

    test('Multiple connectors routing selects the shortest overall path cost', () {
      // Direct path from H001 to H103
      // Option 1 (via conn_g1): H001 -> H002 -> H102 -> H103 (Total dist: 100 + 0 + 50 = 150)
      // Option 2 (via conn_g2): H001 -> H002 -> H003 -> H103 (Total dist: 100 + 100 + 0 = 200)
      final path = PathfindingService.findPath(
        graph: groundFloor.navigationGraph,
        startNodeId: 'H001',
        endNodeId: 'H103',
        floors: floors,
      );

      expect(
        path.map((n) => n.id).toList(),
        ['H001', 'H002', 'H102', 'H103'], // Selected Option 1 (150 vs 200)
      );
    });

    test('No connector available returns empty list', () {
      final groundFloorNoConns = FloorEntity(
        id: groundFloor.id,
        name: groundFloor.name,
        svgPath: groundFloor.svgPath,
        shops: groundFloor.shops,
        navigationGraph: groundFloor.navigationGraph,
        connectors: const [], // Empty connectors
      );

      final path = PathfindingService.findPath(
        graph: groundFloorNoConns.navigationGraph,
        startNodeId: 'H001',
        endNodeId: 'H101',
        floors: [groundFloorNoConns, firstFloor],
      );

      expect(path, isEmpty);
    });

    test('Invalid connector references returns empty list gracefully', () {
      final groundFloorBadConns = FloorEntity(
        id: groundFloor.id,
        name: groundFloor.name,
        svgPath: groundFloor.svgPath,
        shops: groundFloor.shops,
        navigationGraph: groundFloor.navigationGraph,
        connectors: const [
          ConnectorEntity(
            id: 'conn_g1',
            floorId: 'ground_floor',
            navigationNodeId: 'H002',
            connectedConnectorId: 'invalid_connector_ref', // Broken ref
            connectorType: 'escalator',
            accessible: true,
          ),
        ],
      );

      final firstFloorBadConns = FloorEntity(
        id: firstFloor.id,
        name: firstFloor.name,
        svgPath: firstFloor.svgPath,
        shops: firstFloor.shops,
        navigationGraph: firstFloor.navigationGraph,
        connectors: const [
          ConnectorEntity(
            id: 'conn_f1',
            floorId: 'first_floor',
            navigationNodeId: 'H102',
            connectedConnectorId: 'invalid_connector_ref_2', // Broken ref
            connectorType: 'escalator',
            accessible: true,
          ),
        ],
      );

      final path = PathfindingService.findPath(
        graph: groundFloorBadConns.navigationGraph,
        startNodeId: 'H001',
        endNodeId: 'H101',
        floors: [groundFloorBadConns, firstFloorBadConns],
      );

      expect(path, isEmpty);
    });
  });

  group('MapBloc Cross-Floor Integration Tests', () {
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
        shops: const [],
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
      'MapBloc CalculateRoute computes cross-floor path, segments, and correct total distance',
      () async {
        // 1. Initial Load to establish MapLoaded state
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Dispatch CalculateRoute cross-floor event
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

        final state = mapBloc.state as MapLoaded;
        final route = state.activeRoute!;
        final session = state.navigationSession!;

        // Complete route check
        expect(route.completeRoute.map((n) => n.id).toList(), [
          'H001',
          'H002',
          'H102',
          'H101',
        ]);

        // Session checks
        expect(session.nextConnectorId, 'conn_g1');

        // Segmentation verification
        expect(route.segments.length, 3);
        expect(route.segments[0].floorId, 'ground_floor');
        expect(route.segments[0].nodes.map((n) => n.id).toList(), [
          'H001',
          'H002',
        ]);
        expect(route.segments[1].floorId, 'transition');
        expect(route.segments[1].nodes.map((n) => n.id).toList(), [
          'H002',
          'H102',
        ]);
        expect(route.segments[2].floorId, 'first_floor');
        expect(route.segments[2].nodes.map((n) => n.id).toList(), [
          'H102',
          'H101',
        ]);

        // Total distance check: H001->H002 (100) + transition (0) + H102->H101 (100) = 200.0
        expect(route.totalDistance, 200.0);
      },
    );
  });
}

class MockMapRepository implements MapRepository {
  final MapEntity mapData;
  MockMapRepository(this.mapData);

  @override
  Future<MapEntity> getMapData() async => mapData;

  @override
  Future<List<ShopEntity>> searchShops(String query) async => [];

  @override
  Future<ShopEntity?> getShopById(String id) async => null;
}

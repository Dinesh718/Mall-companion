import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/services/navigation_simulation_service.dart';
import 'package:visitor_mall/features/map/data/datasources/simulation_position_provider.dart';
import 'package:visitor_mall/features/map/data/repositories/position_repository_impl.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart'; // Reuse MockMapRepository

void main() {
  group('NavigationSimulationService Tests', () {
    const nodeA = NavigationNodeEntity(
      id: 'A',
      x: 10.0,
      y: 10.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const nodeB = NavigationNodeEntity(
      id: 'B',
      x: 20.0,
      y: 10.0,
      floorId: 'ground_floor',
      type: 'hallway',
    );
    const nodeC = NavigationNodeEntity(
      id: 'C',
      x: 20.0,
      y: 30.0,
      floorId: 'first_floor',
      type: 'hallway',
    );

    test(
      'Interpolates intermediate coordinates and preserves floorId correctly',
      () {
        const route = NavigationRouteEntity(
          completeRoute: [nodeA, nodeB, nodeC],
          segments: [],
          totalDistance: 30.0,
        );

        final path = NavigationSimulationService.generateSimulationPath(
          route,
          positionsPerEdge: 5,
        );

        // Total nodes expected:
        // Edge 1 (A->B): 5 points (ratio 0.0, 0.2, 0.4, 0.6, 0.8)
        // Edge 2 (B->C): 5 points (ratio 0.0, 0.2, 0.4, 0.6, 0.8)
        // Final node C: 1 point
        // Total = 11 points
        expect(path.length, 11);

        // Edge 1 verification (Ground Floor)
        expect(path[0].x, 10.0);
        expect(path[0].floorId, 'ground_floor');
        expect(path[1].x, 12.0); // 10 + 10 * 0.2
        expect(path[4].x, 18.0); // 10 + 10 * 0.8

        // Edge 2 verification (First Floor transitions starts at index 5 which represents Node B heading to C)
        expect(path[5].x, 20.0);
        expect(path[5].y, 10.0);
        expect(
          path[5].floorId,
          'ground_floor',
        ); // Starts from Node B on Ground floor

        expect(path[6].x, 20.0);
        expect(path[6].y, 14.0); // 10 + 20 * 0.2
        expect(
          path[6].floorId,
          'ground_floor',
        ); // Heading to C: ratio 0.2 < 0.5 (still on Ground floor)

        expect(path[8].x, 20.0);
        expect(path[8].y, 22.0); // 10 + 20 * 0.6
        expect(
          path[8].floorId,
          'first_floor',
        ); // Ratio 0.6 >= 0.5 (now transitioned to First floor)

        // Final destination node C
        expect(path.last.x, 20.0);
        expect(path.last.y, 30.0);
        expect(path.last.floorId, 'first_floor');
      },
    );

    test('Handles single node route safely', () {
      const route = NavigationRouteEntity(
        completeRoute: [nodeA],
        segments: [],
        totalDistance: 0.0,
      );

      final path = NavigationSimulationService.generateSimulationPath(route);
      expect(path.length, 1);
      expect(path.first.x, 10.0);
      expect(path.first.floorId, 'ground_floor');
    });

    test('Handles duplicate nodes/zero length edges safely', () {
      const route = NavigationRouteEntity(
        completeRoute: [nodeA, nodeA],
        segments: [],
        totalDistance: 0.0,
      );

      final path = NavigationSimulationService.generateSimulationPath(route);
      expect(path.length, 2);
      expect(path.first.x, 10.0);
      expect(path.last.x, 10.0);
    });
  });

  group('SimulationPositionProvider with direct position paths', () {
    test('Emits direct IndoorPositionEntity items at clock ticks', () async {
      final provider = SimulationPositionProvider();
      final now = DateTime.now();
      final positions = [
        IndoorPositionEntity(
          id: '1',
          floorId: 'g',
          x: 10.0,
          y: 10.0,
          accuracy: 1.0,
          timestamp: now,
          source: PositionSource.simulation,
        ),
        IndoorPositionEntity(
          id: '2',
          floorId: 'g',
          x: 20.0,
          y: 20.0,
          accuracy: 1.0,
          timestamp: now,
          source: PositionSource.simulation,
        ),
      ];

      provider.loadPositionPath(positions);

      final emitted = <IndoorPositionEntity>[];
      final subscription = provider.positionStream.listen(emitted.add);

      provider.start();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(emitted.length, 1);
      expect(emitted.first.x, 10.0);

      provider.stop();
      subscription.cancel();
      provider.dispose();
    });
  });

  group('MapBloc Simulation Integration Tests', () {
    late MockMapRepository mockRepo;
    late SimulationPositionProvider positionProvider;
    late PositionRepositoryImpl positionRepo;
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

    test(
      'MapBloc automatically starts route simulation and updates progress',
      () async {
        positionRepo.loadPositionPath([
          IndoorPositionEntity(
            id: 'pos_start',
            floorId: 'ground_floor',
            x: 100.0,
            y: 100.0,
            accuracy: 1.0,
            timestamp: DateTime.now(),
            source: PositionSource.simulation,
          ),
        ]);

        // 1. Initial Load
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Select Shop and Calculate Route. Should auto-start simulation positioning!
        mapBloc.add(const CalculateRoute(startNodeId: 'N01', endNodeId: 'N02'));

        // 3. Verify latestPosition updates are received and stored inside state
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.latestPosition,
              'latestPosition',
              isNotNull,
            ),
          ),
        );

        final state = mapBloc.state as MapLoaded;
        expect(state.latestPosition, isNotNull);
        expect(
          state.navigationSession!.navigationStatus,
          NavigationStatus.navigating,
        );
      },
    );
  });
}

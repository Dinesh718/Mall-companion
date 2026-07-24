import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/repositories/map_repository.dart';
import 'package:visitor_mall/features/map/domain/entities/shop_category.dart';
import 'package:visitor_mall/features/map/data/datasources/simulation_position_provider.dart';
import 'package:visitor_mall/features/map/data/repositories/position_repository_impl.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';

// Simple Mock Map Repository to support bloc setup
class MockMapRepo implements MapRepository {
  final MapEntity mapData;
  MockMapRepo(this.mapData);

  @override
  Future<MapEntity> getMapData() async => mapData;

  @override
  Future<List<ShopEntity>> searchShops(String query) async {
    return getShops(query: query);
  }

  @override
  Future<ShopEntity?> getShopById(String id) async => null;

  @override
  Future<List<ShopCategory>> getCategories() async {
    return const [
      ShopCategory(id: 'fashion', name: 'Fashion', icon: '👕'),
      ShopCategory(id: 'food', name: 'Food', icon: '🍔'),
    ];
  }

  @override
  Future<List<ShopEntity>> getShopsByCategory(ShopCategory category) async {
    return getShops(category: category);
  }

  @override
  Future<List<ShopEntity>> getShops({
    String? query,
    ShopCategory? category,
  }) async {
    var results = mapData.floors.expand((floor) => floor.shops).toList();

    if (category != null) {
      final catLower = category.name.toLowerCase().trim();
      results = results
          .where((s) => s.category.toLowerCase().trim() == catLower)
          .toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final queryLower = query.toLowerCase().trim();
      results = results
          .where(
            (s) =>
                s.name.toLowerCase().contains(queryLower) ||
                s.category.toLowerCase().contains(queryLower),
          )
          .toList();
    }

    return results;
  }

  @override
  Future<IndoorPositionEntity?> resolveNavigationNode(String nodeId) async {
    for (final floor in mapData.floors) {
      for (final node in floor.navigationGraph.nodes) {
        if (node.id == nodeId) {
          return IndoorPositionEntity(
            id: 'node_$nodeId',
            floorId: floor.id,
            x: node.x,
            y: node.y,
            accuracy: 1.0,
            timestamp: DateTime.now(),
            source: PositionSource.qr,
          );
        }
      }
    }
    return null;
  }
}

void main() {
  group('Positioning Domain and Data Tests', () {
    test('IndoorPositionEntity equality works correctly', () {
      final now = DateTime.now();
      final pos1 = IndoorPositionEntity(
        id: '1',
        floorId: 'g',
        x: 10.0,
        y: 20.0,
        accuracy: 1.0,
        timestamp: now,
        source: PositionSource.ble,
      );
      final pos2 = IndoorPositionEntity(
        id: '1',
        floorId: 'g',
        x: 10.0,
        y: 20.0,
        accuracy: 1.0,
        timestamp: now,
        source: PositionSource.ble,
      );
      final pos3 = IndoorPositionEntity(
        id: '2',
        floorId: 'g',
        x: 10.0,
        y: 20.0,
        accuracy: 1.0,
        timestamp: now,
        source: PositionSource.ble,
      );

      expect(pos1, equals(pos2));
      expect(pos1, isNot(equals(pos3)));
    });

    test('PositionSource enum contains valid sources', () {
      expect(PositionSource.values, contains(PositionSource.simulation));
      expect(PositionSource.values, contains(PositionSource.ble));
      expect(PositionSource.values, contains(PositionSource.qr));
      expect(PositionSource.values, contains(PositionSource.wifi));
      expect(PositionSource.values, contains(PositionSource.uwb));
      expect(PositionSource.values, contains(PositionSource.manual));
      expect(PositionSource.values, contains(PositionSource.sensorFusion));
    });

    test(
      'SimulationPositionProvider emits deterministic path positions',
      () async {
        final provider = SimulationPositionProvider();
        final path = [
          {'x': 1.0, 'y': 2.0},
          {'x': 3.0, 'y': 4.0},
          {'x': 5.0, 'y': 6.0},
        ];

        provider.loadPath(path, floorId: 'ground_floor');

        final emitted = <IndoorPositionEntity>[];
        final subscription = provider.positionStream.listen(emitted.add);

        // Emits the first position immediately on start
        provider.start();

        // Wait a short time to catch initial emission
        await Future.delayed(const Duration(milliseconds: 100));
        expect(emitted.length, 1);
        expect(emitted.first.x, 1.0);
        expect(emitted.first.y, 2.0);
        expect(emitted.first.floorId, 'ground_floor');
        expect(emitted.first.source, PositionSource.simulation);

        provider.stop();
        subscription.cancel();
        provider.dispose();
      },
    );

    test(
      'SimulationPositionProvider reset returns back to start index',
      () async {
        final provider = SimulationPositionProvider();
        final path = [
          {'x': 10.0, 'y': 10.0},
          {'x': 20.0, 'y': 20.0},
        ];

        provider.loadPath(path, floorId: 'floor_1');

        final emitted = <IndoorPositionEntity>[];
        final subscription = provider.positionStream.listen(emitted.add);
        provider.start();

        await Future.delayed(const Duration(milliseconds: 100));
        expect(emitted.last.x, 10.0);

        // Reset and restart should emit index 0 again
        provider.reset();
        provider.start();

        await Future.delayed(const Duration(milliseconds: 100));
        expect(emitted.last.x, 10.0);

        provider.stop();
        subscription.cancel();
        provider.dispose();
      },
    );

    test('PositionRepository forwards stream and control commands', () async {
      final provider = SimulationPositionProvider();
      final repository = PositionRepositoryImpl(provider);

      final path = [
        {'x': 5.0, 'y': 5.0},
      ];
      repository.loadSimulationPath(path, floorId: 'g');

      final emitted = <IndoorPositionEntity>[];
      final subscription = repository.positionStream.listen(emitted.add);

      repository.startPositioning();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(emitted.length, 1);
      expect(emitted.first.x, 5.0);

      repository.stopPositioning();
      subscription.cancel();
      provider.dispose();
    });
  });

  group('MapBloc Positioning Integration Tests', () {
    late MockMapRepo mockMapRepo;
    late SimulationPositionProvider positionProvider;
    late PositionRepositoryImpl positionRepo;
    late MapBloc mapBloc;

    setUp(() {
      const groundFloor = FloorEntity(
        id: 'ground_floor',
        name: 'Ground Floor',
        svgPath: '',
        shops: [],
        navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
        connectors: [],
      );
      final mapEntity = MapEntity(id: 'mall_1', floors: const [groundFloor]);

      mockMapRepo = MockMapRepo(mapEntity);
      positionProvider = SimulationPositionProvider();
      positionRepo = PositionRepositoryImpl(positionProvider);
      mapBloc = MapBloc(
        mapRepository: mockMapRepo,
        positionRepository: positionRepo,
      );
    });

    tearDown(() {
      mapBloc.close();
      positionProvider.dispose();
    });

    test(
      'MapBloc handles positioning lifecycle and stores latestPosition',
      () async {
        // 1. Initial Load
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Load path in simulation repo
        final path = [
          {'x': 50.0, 'y': 60.0},
        ];
        positionRepo.loadSimulationPath(path, floorId: 'ground_floor');

        // 3. Start positioning
        mapBloc.add(const StartPositioning());

        // 4. Verify MapLoaded is updated with simulation coordinates
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
        expect(state.latestPosition!.x, 50.0);
        expect(state.latestPosition!.y, 60.0);
        expect(state.latestPosition!.floorId, 'ground_floor');
        expect(state.latestPosition!.source, PositionSource.simulation);

        // 5. Stop positioning cancels updates
        mapBloc.add(const StopPositioning());
      },
    );
  });
}

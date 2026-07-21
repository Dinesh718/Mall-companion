import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';

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

  setUp(() {
    final datasource = LocalMapDataSourceImpl(assetBundle: TestAssetBundle());
    repository = DummyMapRepository(localDataSource: datasource);
    mapBloc = MapBloc(mapRepository: repository);
  });

  tearDown(() {
    mapBloc.close();
  });

  group('Navigation Session Management Tests', () {
    test('Selecting a shop sets selection but keeps route null', () async {
      // 1. Initial Load
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      final stateAfterLoad = mapBloc.state as MapLoaded;
      expect(stateAfterLoad.selectedShopId, isNull);
      expect(stateAfterLoad.activeRoute, isNull);

      // 2. Select Shop
      mapBloc.add(const SelectShop('shop_001'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.selectedShopId,
            'selectedShopId',
            'shop_001',
          ),
        ),
      );

      final stateAfterSelect = mapBloc.state as MapLoaded;
      expect(stateAfterSelect.selectedShopId, 'shop_001');
      expect(
        stateAfterSelect.activeRoute,
        isNull,
      ); // Verify route is NOT auto-calculated
    });

    test(
      'Explicit CalculateRoute computes and stores the path, and SelectShop clears it',
      () async {
        // 1. Load map
        mapBloc.add(const LoadMap());
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 2. Select Shop
        mapBloc.add(const SelectShop('shop_001'));
        await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

        // 3. Calculate Route (Simulating bottom sheet button action)
        mapBloc.add(
          const CalculateRoute(startNodeId: 'H001', endNodeId: 'E002'),
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

        final stateAfterRoute = mapBloc.state as MapLoaded;
        expect(stateAfterRoute.activeRoute, isNotNull);
        expect(stateAfterRoute.activeRoute!.completeRoute, isNotEmpty);
        expect(stateAfterRoute.activeRoute!.completeRoute.first.id, 'H001');
        expect(stateAfterRoute.activeRoute!.completeRoute.last.id, 'E002');

        // 4. Select a different shop - verifies old route is cleared
        mapBloc.add(const SelectShop('shop_002'));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.activeRoute,
              'activeRoute',
              isNull,
            ),
          ),
        );

        final stateAfterNewSelect = mapBloc.state as MapLoaded;
        expect(stateAfterNewSelect.selectedShopId, 'shop_002');
        expect(stateAfterNewSelect.activeRoute, isNull);
      },
    );

    test('ClearRoute event removes activeRoute', () async {
      // 1. Load map
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 2. Calculate route
      mapBloc.add(const CalculateRoute(startNodeId: 'H001', endNodeId: 'E002'));
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 3. Clear route
      mapBloc.add(const ClearRoute());
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having((s) => s.activeRoute, 'activeRoute', isNull),
        ),
      );

      final finalState = mapBloc.state as MapLoaded;
      expect(finalState.activeRoute, isNull);
    });
  });
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';

// A mock asset bundle that returns the local JSON file contents
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
  late MapBloc bloc;

  setUp(() {
    final datasource = LocalMapDataSourceImpl(assetBundle: TestAssetBundle());
    repository = DummyMapRepository(localDataSource: datasource);
    bloc = MapBloc(mapRepository: repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('Map Search Repository Tests', () {
    test(
      'searchShops is case-insensitive and supports partial matches',
      () async {
        // Warm up the cache
        await repository.getMapData();

        // Test "Nike"
        final nikeResults = await repository.searchShops('Nike');
        expect(nikeResults.any((s) => s.name.contains('Nike Store')), isTrue);

        // Test "pizza"
        final pizzaResults = await repository.searchShops('pizza');
        expect(pizzaResults.any((s) => s.name.contains('Pizza Hut')), isTrue);
        expect(
          pizzaResults.any((s) => s.name.contains('Pizza Hut Express')),
          isTrue,
        );

        // Test "STAR"
        final starResults = await repository.searchShops('STAR');
        expect(starResults.any((s) => s.name.contains('Starbucks')), isTrue);
        expect(
          starResults.any((s) => s.name.contains('Starbucks Coffee')),
          isTrue,
        );
      },
    );
  });

  group('Map Search BLoC Tests', () {
    test(
      'SearchShops event performs lookup and updates searchResults state',
      () async {
        bloc.add(const LoadMap());
        await expectLater(bloc.stream, emitsThrough(isA<MapLoaded>()));

        bloc.add(const SearchShops('Nike'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<MapLoaded>()
                .having(
                  (state) => state.searchResults,
                  'searchResults',
                  isNotEmpty,
                )
                .having((state) => state.searchQuery, 'searchQuery', 'Nike'),
          ),
        );
      },
    );

    test(
      'ClearSearch event resets searchResults and searchQuery to null',
      () async {
        bloc.add(const LoadMap());
        await expectLater(bloc.stream, emitsThrough(isA<MapLoaded>()));

        bloc.add(const SearchShops('Nike'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.searchQuery,
              'searchQuery',
              'Nike',
            ),
          ),
        );

        bloc.add(const ClearSearch());
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<MapLoaded>()
                .having((s) => s.searchResults, 'searchResults', isNull)
                .having((s) => s.searchQuery, 'searchQuery', isNull),
          ),
        );
      },
    );

    test(
      'SelectShop updates selectedShopId and ClearSelection clears it',
      () async {
        bloc.add(const LoadMap());
        await expectLater(bloc.stream, emitsThrough(isA<MapLoaded>()));

        bloc.add(const SelectShop('shop_003'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.selectedShopId,
              'selectedShopId',
              'shop_003',
            ),
          ),
        );

        bloc.add(const ClearSelection());
        await expectLater(
          bloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.selectedShopId,
              'selectedShopId',
              isNull,
            ),
          ),
        );
      },
    );
  });
}

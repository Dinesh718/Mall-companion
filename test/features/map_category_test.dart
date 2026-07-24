import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/shop_category.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'map_crossfloor_test.dart'; // Reuse MockMapRepository

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Category Domain and Repository Tests', () {
    const fashionCategory = ShopCategory(
      id: 'fashion',
      name: 'Fashion',
      icon: '👕',
    );
    const foodCategory = ShopCategory(id: 'food', name: 'Food', icon: '🍔');

    const shop1 = ShopEntity(
      id: 'S1',
      name: 'Zara',
      category: 'Fashion',
      description: 'Zara store',
      status: 'open',
      rating: 4.5,
      offer: 'None',
      geometry: RectangleGeometry(x: 0, y: 0, width: 10, height: 10),
      entranceNodeIds: ['E1'],
    );
    const shop2 = ShopEntity(
      id: 'S2',
      name: 'McDonalds',
      category: 'Food',
      description: 'Mickey D',
      status: 'open',
      rating: 4.0,
      offer: 'None',
      geometry: RectangleGeometry(x: 10, y: 0, width: 10, height: 10),
      entranceNodeIds: ['E2'],
    );

    const floor = FloorEntity(
      id: 'ground_floor',
      name: 'Ground Floor',
      svgPath: 'assets/svg/maps/ground_floor.svg',
      shops: [shop1, shop2],
      navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
      connectors: [],
    );

    final mapEntity = MapEntity(id: 'mall', floors: [floor]);
    final mockRepo = MockMapRepository(mapEntity);

    test('getCategories returns standard mall categories list', () async {
      final categories = await mockRepo.getCategories();
      expect(categories, isNotEmpty);
      expect(categories.any((c) => c.id == 'fashion'), isTrue);
      expect(categories.any((c) => c.id == 'food'), isTrue);
    });

    test('getShopsByCategory returns only matching shops', () async {
      final fashionShops = await mockRepo.getShopsByCategory(fashionCategory);
      expect(fashionShops.length, 1);
      expect(fashionShops.first.id, 'S1');

      final foodShops = await mockRepo.getShopsByCategory(foodCategory);
      expect(foodShops.length, 1);
      expect(foodShops.first.id, 'S2');
    });
  });

  group('MapBloc Category Integration Tests', () {
    const fashionCategory = ShopCategory(
      id: 'fashion',
      name: 'Fashion',
      icon: '👕',
    );

    const shop1 = ShopEntity(
      id: 'S1',
      name: 'Zara',
      category: 'Fashion',
      description: 'Zara store',
      status: 'open',
      rating: 4.5,
      offer: 'None',
      geometry: RectangleGeometry(x: 0, y: 0, width: 10, height: 10),
      entranceNodeIds: ['E1'],
    );
    const shop2 = ShopEntity(
      id: 'S2',
      name: 'McDonalds',
      category: 'Food',
      description: 'Mickey D',
      status: 'open',
      rating: 4.0,
      offer: 'None',
      geometry: RectangleGeometry(x: 10, y: 0, width: 10, height: 10),
      entranceNodeIds: ['E2'],
    );

    const floor = FloorEntity(
      id: 'ground_floor',
      name: 'Ground Floor',
      svgPath: 'assets/svg/maps/ground_floor.svg',
      shops: [shop1, shop2],
      navigationGraph: NavigationGraphEntity(nodes: [], edges: []),
      connectors: [],
    );

    final mapEntity = MapEntity(id: 'mall', floors: [floor]);
    late MockMapRepository mockRepo;
    late MapBloc mapBloc;

    setUp(() {
      mockRepo = MockMapRepository(mapEntity);
      mapBloc = MapBloc(mapRepository: mockRepo);
    });

    tearDown(() {
      mapBloc.close();
    });

    test(
      'MapBloc populates categories and handles selection updates correctly',
      () async {
        // 1. Load Map (also triggers LoadCategories automatically)
        mapBloc.add(const LoadMap());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.categories,
              'categories',
              isNotEmpty,
            ),
          ),
        );

        var state = mapBloc.state as MapLoaded;
        expect(state.displayedShops.length, 2); // Zara and McDonalds

        // 2. Select Fashion category
        mapBloc.add(const SelectCategory(fashionCategory));
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.selectedCategory,
              'selectedCategory',
              fashionCategory,
            ),
          ),
        );

        state = mapBloc.state as MapLoaded;
        expect(state.displayedShops.length, 1);
        expect(state.displayedShops.first.id, 'S1'); // Zara only

        // 3. Clear category filter
        mapBloc.add(const ClearCategory());
        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.selectedCategory,
              'selectedCategory',
              isNull,
            ),
          ),
        );

        state = mapBloc.state as MapLoaded;
        expect(state.displayedShops.length, 2); // Both Zara and McDonalds again
      },
    );

    test('MapBloc combined search + category logic works correctly', () async {
      mapBloc.add(const LoadMap());
      await expectLater(mapBloc.stream, emitsThrough(isA<MapLoaded>()));

      // 1. Select Fashion category
      mapBloc.add(const SelectCategory(fashionCategory));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.selectedCategory,
            'selectedCategory',
            fashionCategory,
          ),
        ),
      );

      // 2. Perform text search matching 'Zara' (which is Fashion category)
      mapBloc.add(const SearchShops('Zara'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.searchResults?.length,
            'searchResults matching Zara',
            1,
          ),
        ),
      );

      // 3. Perform text search matching 'McDonalds' (which is Food category, so should return empty results when combined with Fashion category filter)
      mapBloc.add(const SearchShops('McDonalds'));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>().having(
            (s) => s.searchResults?.length,
            'searchResults combined mismatch',
            0,
          ),
        ),
      );

      // 4. Toggle/Select selected category again to toggle it off, restoring search matching 'McDonalds'
      mapBloc.add(const SelectCategory(fashionCategory));
      await expectLater(
        mapBloc.stream,
        emitsThrough(
          isA<MapLoaded>()
              .having(
                (s) => s.selectedCategory,
                'selectedCategory cleared',
                isNull,
              )
              .having(
                (s) => s.searchResults?.length,
                'searchResults McDonald restored',
                1,
              ),
        ),
      );
    });
  });
}

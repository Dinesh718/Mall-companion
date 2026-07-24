import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/navigation/domain/services/destination_switch_service.dart';

void main() {
  group('DestinationSwitchService Unit Tests', () {
    late MapEntity mapEntity;
    late IndoorPositionEntity currentPos;

    setUp(() {
      final n1 = NavigationNodeEntity(
        id: 'node_1',
        floorId: 'floor_1',
        x: 100.0,
        y: 100.0,
        type: 'normal',
      );
      final n2 = NavigationNodeEntity(
        id: 'node_2',
        floorId: 'floor_1',
        x: 200.0,
        y: 200.0,
        type: 'normal',
      );
      final n3 = NavigationNodeEntity(
        id: 'node_3',
        floorId: 'floor_1',
        x: 300.0,
        y: 300.0,
        type: 'normal',
      );

      final edge1 = NavigationEdgeEntity(
        fromNodeId: 'node_1',
        toNodeId: 'node_2',
        distance: 10.0,
      );
      final edge2 = NavigationEdgeEntity(
        fromNodeId: 'node_2',
        toNodeId: 'node_3',
        distance: 15.0,
      );

      final shopA = ShopEntity(
        id: 'shop_A',
        name: 'Shop A',
        category: 'Fashion',
        description: 'Shop A Desc',
        status: 'Open',
        rating: 4.5,
        offer: 'None',
        geometry: const RectangleGeometry(x: 50, y: 50, width: 60, height: 60),
        entranceNodeIds: const ['node_1'],
      );

      final shopB = ShopEntity(
        id: 'shop_B',
        name: 'Shop B',
        category: 'Food',
        description: 'Shop B Desc',
        status: 'Open',
        rating: 4.5,
        offer: 'None',
        geometry: const RectangleGeometry(
          x: 280,
          y: 280,
          width: 40,
          height: 40,
        ),
        entranceNodeIds: const ['node_3'],
      );

      final floor = FloorEntity(
        id: 'floor_1',
        name: 'Floor 1',
        svgPath: '',
        shops: [shopA, shopB],
        navigationGraph: NavigationGraphEntity(
          nodes: [n1, n2, n3],
          edges: [edge1, edge2],
        ),
        connectors: const [],
      );

      mapEntity = MapEntity(id: 'mall_1', floors: [floor]);

      currentPos = IndoorPositionEntity(
        id: 'user_pos',
        floorId: 'floor_1',
        x: 205.0,
        y: 205.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );
    });

    test(
      'switchDestination returns a valid new route starting from current position',
      () {
        final route = DestinationSwitchService.switchDestination(
          mapEntity: mapEntity,
          currentPosition: currentPos,
          newDestinationShopId: 'shop_B',
        );

        expect(route, isNotNull);
        expect(route!.completeRoute.first.id, 'node_2');
        expect(route!.completeRoute.last.id, 'node_3');
        expect(route.totalDistance, 15.0);
      },
    );

    test('switchDestination returns null if destination shop is not found', () {
      final route = DestinationSwitchService.switchDestination(
        mapEntity: mapEntity,
        currentPosition: currentPos,
        newDestinationShopId: 'non_existent_shop',
      );

      expect(route, isNull);
    });
  });
}

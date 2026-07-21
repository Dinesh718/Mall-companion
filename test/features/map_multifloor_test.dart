import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/models/map_models.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';

void main() {
  group('Multi-Floor Routing Architecture Tests', () {
    test(
      'ConnectorModel parsing handles valid values and maps to entity properties',
      () {
        final jsonMap = {
          'id': 'conn_001',
          'floorId': 'ground_floor',
          'navigationNodeId': 'H001',
          'connectedConnectorId': 'conn_101',
          'connectorType': 'escalator',
          'accessible': true,
          'metadata': {'speed': 'normal'},
        };

        final model = ConnectorModel.fromJson(jsonMap);
        expect(model.id, 'conn_001');
        expect(model.floorId, 'ground_floor');
        expect(model.navigationNodeId, 'H001');
        expect(model.connectedConnectorId, 'conn_101');
        expect(model.connectorType, 'escalator');
        expect(model.accessible, isTrue);
        expect(model.metadata, isNotNull);
        expect(model.metadata!['speed'], 'normal');

        final entity = model as ConnectorEntity;
        expect(entity.id, 'conn_001');
      },
    );

    test(
      'FloorModel constructor successfully parses empty connectors list as default fallback',
      () {
        final jsonMap = {
          'id': 'ground_floor',
          'name': 'Ground Floor',
          'svgPath': 'assets/svg/maps/ground_floor.svg',
          'shops': [],
          'navigation': {'nodes': [], 'edges': []},
        };

        final floor = FloorModel.fromJson(jsonMap);
        expect(floor.id, 'ground_floor');
        expect(floor.connectors, isEmpty); // Fallback works cleanly
      },
    );

    test(
      'NavigationRouteEntity encapsulates ordered segments and computes metadata properties',
      () {
        const node1 = NavigationNodeEntity(
          id: 'H001',
          x: 10.0,
          y: 20.0,
          floorId: 'ground_floor',
          type: 'hallway',
        );
        const node2 = NavigationNodeEntity(
          id: 'H002',
          x: 50.0,
          y: 20.0,
          floorId: 'ground_floor',
          type: 'hallway',
        );

        const segment = RouteSegmentEntity(
          floorId: 'ground_floor',
          nodes: [node1, node2],
        );

        const route = NavigationRouteEntity(
          completeRoute: [node1, node2],
          segments: [segment],
          totalDistance: 40.0,
          destinationMetadata: 'HM Entrance',
        );

        expect(route.completeRoute.length, 2);
        expect(route.segments.length, 1);
        expect(route.totalDistance, 40.0);
        expect(route.destinationMetadata, 'HM Entrance');
      },
    );
  });
}

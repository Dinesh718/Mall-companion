import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/data/datasources/local_map_datasource.dart';
import 'package:visitor_mall/features/map/data/repositories/dummy_map_repository.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';

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

  setUp(() {
    final datasource = LocalMapDataSourceImpl(assetBundle: TestAssetBundle());
    repository = DummyMapRepository(localDataSource: datasource);
  });

  group('Navigation Graph Foundation Tests - Shop Entrance Nodes', () {
    test(
      'JSON loads navigation graph hallways and entrances successfully and parses shop entranceNodeIds',
      () async {
        final mapData = await repository.getMapData();
        expect(mapData.floors, isNotEmpty);

        final floor = mapData.floors.first;
        final graph = floor.navigationGraph;

        // Verify node and edge counts (10 hallway nodes + 33 shop entrance nodes + 1 lift node)
        expect(graph.nodes.length, 44);
        expect(graph.edges.length, 43);

        // Verify that shops map to entrance nodes in walkable space
        final zara = floor.shops.firstWhere((s) => s.id == 'shop_001');
        expect(zara.entranceNodeIds, contains('E001'));

        final hm = floor.shops.firstWhere((s) => s.id == 'shop_002');
        expect(hm.entranceNodeIds, contains('E002'));

        // Verify specific entrance node values (Zara entrance at bottom edge)
        final eNode = graph.nodes.firstWhere((n) => n.id == 'E001');
        expect(eNode.type, 'entrance');
        expect(eNode.x, 118.5);
        expect(eNode.y, 403.0);
        expect(eNode.floorId, 'ground_floor');

        // Verify hallway nodes are parsed
        final hNode = graph.nodes.firstWhere((n) => n.id == 'H001');
        expect(hNode.type, 'hallway');
        expect(hNode.x, 100.0);
        expect(hNode.y, 440.0);
        expect(hNode.floorId, 'ground_floor');
      },
    );
  });
}

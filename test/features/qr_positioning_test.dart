import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/shop_category.dart';
import 'package:visitor_mall/features/map/domain/repositories/map_repository.dart';
import 'package:visitor_mall/features/map/domain/repositories/position_repository.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_bloc.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_event.dart';
import 'package:visitor_mall/features/map/presentation/bloc/map_state.dart';
import 'package:visitor_mall/features/positioning/data/datasource/qr_local_datasource.dart';
import 'package:visitor_mall/features/positioning/data/repository/qr_position_repository_impl.dart';
import 'package:visitor_mall/features/positioning/presentation/pages/qr_scanner_page.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:flutter/material.dart';

class MockAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError();
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/data/maps/qr_mappings.json') {
      return json.encode({
        "QR_001": {"navigationNodeId": "H001"},
      });
    }
    throw FlutterError('Unknown asset key: $key');
  }
}

class MockMapRepo implements MapRepository {
  @override
  Future<IndoorPositionEntity?> resolveNavigationNode(String nodeId) async {
    if (nodeId == 'H001') {
      return IndoorPositionEntity(
        id: 'node_H001',
        floorId: 'ground_floor',
        x: 1000.0,
        y: 440.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.qr,
      );
    }
    return null;
  }

  @override
  Future<MapEntity> getMapData() async => throw UnimplementedError();

  @override
  Future<List<ShopEntity>> searchShops(String query) async => [];

  @override
  Future<ShopEntity?> getShopById(String id) async => null;

  @override
  Future<List<ShopCategory>> getCategories() async => [];

  @override
  Future<List<ShopEntity>> getShopsByCategory(ShopCategory category) async =>
      [];

  @override
  Future<List<ShopEntity>> getShops({
    String? query,
    ShopCategory? category,
  }) async => [];
}

class MockPositionRepo implements PositionRepository {
  List<IndoorPositionEntity> loadedPositions = [];

  @override
  Stream<IndoorPositionEntity> get positionStream => Stream.empty();

  @override
  void startPositioning() {}

  @override
  void stopPositioning() {}

  @override
  void resetPositioning() {}

  @override
  void loadSimulationPath(
    List<Map<String, double>> path, {
    required String floorId,
  }) {}

  @override
  void loadPositionPath(List<IndoorPositionEntity> positions) {
    loadedPositions = positions;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QR Positioning Unit and Data Tests', () {
    late MockAssetBundle mockAssetBundle;
    late QrLocalDataSource dataSource;
    late QrPositionRepositoryImpl repository;

    setUp(() {
      mockAssetBundle = MockAssetBundle();
      dataSource = QrLocalDataSourceImpl(assetBundle: mockAssetBundle);
      repository = QrPositionRepositoryImpl(
        localDataSource: dataSource,
        mapRepository: MockMapRepo(),
      );
    });

    test('QrLocalDataSource retrieves mapping from JSON', () async {
      final mapping = await dataSource.getQrMapping('QR_001');
      expect(mapping, isNotNull);
      expect(mapping!['navigationNodeId'], 'H001');
    });

    test(
      'QrPositionRepositoryImpl resolves mapping to IndoorPositionEntity',
      () async {
        final position = await repository.getPositionByQrId('QR_001');
        expect(position, isNotNull);
        expect(position!.x, 1000.0);
        expect(position.floorId, 'ground_floor');
        expect(position.source, PositionSource.qr);
      },
    );

    test('QrPositionRepositoryImpl returns null for unknown QR ID', () async {
      final position = await repository.getPositionByQrId('QR_UNKNOWN');
      expect(position, isNull);
    });
  });

  group('MapBloc QR Coordination Tests', () {
    late MockAssetBundle mockAssetBundle;
    late QrLocalDataSource dataSource;
    late QrPositionRepositoryImpl qrRepository;
    late MockMapRepo mockMapRepo;
    late MockPositionRepo mockPositionRepo;
    late MapBloc mapBloc;

    setUp(() {
      mockAssetBundle = MockAssetBundle();
      dataSource = QrLocalDataSourceImpl(assetBundle: mockAssetBundle);
      mockMapRepo = MockMapRepo();
      mockPositionRepo = MockPositionRepo();
      qrRepository = QrPositionRepositoryImpl(
        localDataSource: dataSource,
        mapRepository: mockMapRepo,
      );
      mapBloc = MapBloc(
        mapRepository: mockMapRepo,
        positionRepository: mockPositionRepo,
        qrPositionRepository: qrRepository,
      );
    });

    tearDown(() {
      mapBloc.close();
    });

    test(
      'ScanQrPositionRequested resolves coordinates, updates PositionRepository and emits state',
      () async {
        final mapData = MapEntity(
          id: 'mall',
          floors: [
            FloorEntity(
              id: 'ground_floor',
              name: 'Ground Floor',
              svgPath: '',
              shops: const [],
              navigationGraph: NavigationGraphEntity(
                nodes: [
                  NavigationNodeEntity(
                    id: 'H001',
                    x: 1000.0,
                    y: 440.0,
                    floorId: 'ground_floor',
                    type: 'hallway',
                  ),
                ],
                edges: const [],
              ),
              connectors: const [],
            ),
          ],
        );

        mapBloc.emit(
          MapLoaded(
            mapEntity: mapData,
            currentFloor: mapData.floors.first,
            shops: const [],
          ),
        );

        mapBloc.add(const ScanQrPositionRequested('QR_001'));

        await expectLater(
          mapBloc.stream,
          emitsThrough(
            isA<MapLoaded>().having(
              (s) => s.latestPosition?.x,
              'latestPosition.x',
              1000.0,
            ),
          ),
        );

        expect(mockPositionRepo.loadedPositions.length, 1);
        expect(mockPositionRepo.loadedPositions.first.x, 1000.0);
      },
    );
  });

  group('QR Scanner Page Widget Tests', () {
    testWidgets(
      'QRScannerPage renders scanner simulator and triggers pops on scan simulation',
      (WidgetTester tester) async {
        String? scanResult;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      scanResult = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QrScannerPage(),
                        ),
                      );
                    },
                    child: const Text('Open Scanner'),
                  ),
                );
              },
            ),
          ),
        );

        // Open scanner
        await tester.tap(find.text('Open Scanner'));
        await tester.pumpAndSettle();

        // Verify Scanner Simulator interface renders
        expect(find.text('Camera Scanner Simulator'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Simulate Scan'), findsOneWidget);

        // Enter mock QR code
        await tester.enterText(find.byType(TextField), 'QR_002');
        await tester.pump();

        // Trigger Simulation
        await tester.tap(find.text('Simulate Scan'));
        await tester.pumpAndSettle();

        // Verify page is popped and result is returned
        expect(find.text('Camera Scanner Simulator'), findsNothing);
        expect(scanResult, 'QR_002');
      },
    );
  });
}

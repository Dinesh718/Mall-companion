import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/repositories/position_repository.dart';
import 'package:visitor_mall/features/navigation/domain/entities/active_position_source_entity.dart';
import 'package:visitor_mall/features/navigation/domain/services/position_source_orchestrator.dart';

class FakePositionRepository implements PositionRepository {
  final StreamController<IndoorPositionEntity> _controller =
      StreamController<IndoorPositionEntity>.broadcast();

  bool isStarted = false;
  bool isStopped = false;
  List<IndoorPositionEntity> loadedPaths = [];

  @override
  Stream<IndoorPositionEntity> get positionStream => _controller.stream;

  @override
  void startPositioning() {
    isStarted = true;
    isStopped = false;
  }

  @override
  void stopPositioning() {
    isStopped = true;
    isStarted = false;
  }

  @override
  void resetPositioning() {
    isStarted = false;
    isStopped = false;
    loadedPaths.clear();
  }

  @override
  void loadSimulationPath(
    List<Map<String, double>> path, {
    required String floorId,
  }) {}

  @override
  void loadPositionPath(List<IndoorPositionEntity> positions) {
    loadedPaths = positions;
  }

  void emitPosition(IndoorPositionEntity position) {
    _controller.add(position);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  late FakePositionRepository fakeRepo;
  late PositionSourceOrchestrator orchestrator;

  setUp(() {
    fakeRepo = FakePositionRepository();
    orchestrator = PositionSourceOrchestrator(positionRepository: fakeRepo);
  });

  tearDown(() {
    orchestrator.dispose();
    fakeRepo.dispose();
  });

  group('PositionSourceOrchestrator Unit Tests', () {
    test('Initial state: currentSource is null and stream does not emit', () {
      expect(orchestrator.currentSource, isNull);
    });

    test('activateSimulation: sets source and forwards events', () async {
      orchestrator.activateSimulation();
      expect(orchestrator.currentSource, PositionSourceType.simulation);
      expect(fakeRepo.isStarted, isTrue);

      final testPosition = IndoorPositionEntity(
        id: 'sim_pos',
        floorId: 'ground_floor',
        x: 100.0,
        y: 200.0,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      );

      final streamExpectation = expectLater(
        orchestrator.positionStream,
        emits(testPosition),
      );

      fakeRepo.emitPosition(testPosition);
      await streamExpectation;
    });

    test(
      'activateQr: sets source, stops simulation, and emits scanned position',
      () async {
        orchestrator.activateSimulation();
        expect(fakeRepo.isStarted, isTrue);

        final qrPosition = IndoorPositionEntity(
          id: 'qr_pos',
          floorId: 'ground_floor',
          x: 500.0,
          y: 600.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.qr,
        );

        final streamExpectation = expectLater(
          orchestrator.positionStream,
          emits(qrPosition),
        );

        orchestrator.activateQr(qrPosition);

        expect(orchestrator.currentSource, PositionSourceType.qr);
        expect(fakeRepo.isStopped, isTrue); // stops simulation!
        expect(fakeRepo.loadedPaths, contains(qrPosition));

        await streamExpectation;
      },
    );

    test(
      'deactivateCurrentSource: stops simulation and resets currentSource',
      () {
        orchestrator.activateSimulation();
        expect(orchestrator.currentSource, PositionSourceType.simulation);

        orchestrator.deactivateCurrentSource();
        expect(orchestrator.currentSource, isNull);
        expect(fakeRepo.isStopped, isTrue);
      },
    );

    test(
      'switching between simulation and QR behaves deterministically',
      () async {
        orchestrator.activateSimulation();
        expect(orchestrator.currentSource, PositionSourceType.simulation);

        final qrPosition = IndoorPositionEntity(
          id: 'qr_pos_2',
          floorId: 'ground_floor',
          x: 300.0,
          y: 400.0,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.qr,
        );

        orchestrator.activateQr(qrPosition);
        expect(orchestrator.currentSource, PositionSourceType.qr);
        expect(fakeRepo.isStopped, isTrue);

        orchestrator.activateSimulation();
        expect(orchestrator.currentSource, PositionSourceType.simulation);
        expect(fakeRepo.isStarted, isTrue);
      },
    );
  });
}

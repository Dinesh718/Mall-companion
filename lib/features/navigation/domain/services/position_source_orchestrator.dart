import 'dart:async';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/repositories/position_repository.dart';
import '../entities/active_position_source_entity.dart';

class PositionSourceOrchestrator {
  final PositionRepository positionRepository;

  PositionSourceType? _currentSource;
  final StreamController<IndoorPositionEntity> _positionStreamController =
      StreamController<IndoorPositionEntity>.broadcast();
  StreamSubscription<IndoorPositionEntity>? _simulationSubscription;

  PositionSourceOrchestrator({required this.positionRepository});

  PositionSourceType? get currentSource => _currentSource;

  Stream<IndoorPositionEntity> get positionStream =>
      _positionStreamController.stream;

  void activateSimulation() {
    if (_currentSource == PositionSourceType.simulation) return;

    _deactivateCurrent();

    _currentSource = PositionSourceType.simulation;

    _simulationSubscription = positionRepository.positionStream.listen((
      position,
    ) {
      if (_currentSource == PositionSourceType.simulation) {
        _positionStreamController.add(position);
      }
    });

    positionRepository.startPositioning();
  }

  void activateQr(IndoorPositionEntity position) {
    if (_currentSource == PositionSourceType.qr) {
      // Still push the new QR position update
      positionRepository.loadPositionPath([position]);
      _positionStreamController.add(position);
      return;
    }

    _deactivateCurrent();

    _currentSource = PositionSourceType.qr;

    positionRepository.loadPositionPath([position]);
    _positionStreamController.add(position);
  }

  void deactivateCurrentSource() {
    _deactivateCurrent();
  }

  void _deactivateCurrent() {
    if (_currentSource == PositionSourceType.simulation) {
      _simulationSubscription?.cancel();
      _simulationSubscription = null;
      positionRepository.stopPositioning();
    }
    _currentSource = null;
  }

  void dispose() {
    _deactivateCurrent();
    _positionStreamController.close();
  }
}

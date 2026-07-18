import '../../domain/entities/position_entities.dart';
import '../../domain/repositories/position_repository.dart';
import '../../domain/services/position_provider.dart';

class PositionRepositoryImpl implements PositionRepository {
  final IndoorPositionProvider _provider;

  PositionRepositoryImpl(this._provider);

  @override
  Stream<IndoorPositionEntity> get positionStream => _provider.positionStream;

  @override
  void startPositioning() {
    _provider.start();
  }

  @override
  void stopPositioning() {
    _provider.stop();
  }

  @override
  void resetPositioning() {
    _provider.reset();
  }

  @override
  void loadSimulationPath(
    List<Map<String, double>> path, {
    required String floorId,
  }) {
    _provider.loadPath(path, floorId: floorId);
  }

  @override
  void loadPositionPath(List<IndoorPositionEntity> positions) {
    _provider.loadPositionPath(positions);
  }
}

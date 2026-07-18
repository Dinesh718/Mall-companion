import '../entities/position_entities.dart';

abstract class PositionRepository {
  Stream<IndoorPositionEntity> get positionStream;
  void startPositioning();
  void stopPositioning();
  void resetPositioning();
  void loadSimulationPath(
    List<Map<String, double>> path, {
    required String floorId,
  });
  void loadPositionPath(List<IndoorPositionEntity> positions);
}

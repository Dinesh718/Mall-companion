import '../entities/position_entities.dart';

abstract class IndoorPositionProvider {
  Stream<IndoorPositionEntity> get positionStream;
  void start();
  void stop();
  void reset();
  void loadPath(List<Map<String, double>> path, {required String floorId});
  void loadPositionPath(List<IndoorPositionEntity> positions);
  void dispose();
}

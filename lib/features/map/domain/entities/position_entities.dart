import 'package:equatable/equatable.dart';

enum PositionSource { simulation, ble, qr, wifi, uwb, manual, sensorFusion }

class IndoorPositionEntity extends Equatable {
  final String id;
  final String floorId;
  final double x;
  final double y;
  final double accuracy;
  final DateTime timestamp;
  final PositionSource source;

  const IndoorPositionEntity({
    required this.id,
    required this.floorId,
    required this.x,
    required this.y,
    required this.accuracy,
    required this.timestamp,
    required this.source,
  });

  @override
  List<Object?> get props => [id, floorId, x, y, accuracy, timestamp, source];
}

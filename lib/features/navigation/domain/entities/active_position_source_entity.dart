import 'package:equatable/equatable.dart';

enum PositionSourceType {
  simulation,
  qr,
  ble,
  wifi,
  sensorFusion,
  backend,
  manual,
}

class ActivePositionSourceEntity extends Equatable {
  final PositionSourceType type;

  const ActivePositionSourceEntity({required this.type});

  @override
  List<Object?> get props => [type];
}

import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMap extends MapEvent {
  const LoadMap();
}

class SelectShop extends MapEvent {
  final String shopId;

  const SelectShop(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class ClearSelection extends MapEvent {
  const ClearSelection();
}

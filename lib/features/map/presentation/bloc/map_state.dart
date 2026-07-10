import 'package:equatable/equatable.dart';
import '../../domain/entities/map_entities.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final MapEntity mapEntity;
  final FloorEntity currentFloor;
  final List<ShopEntity> shops;
  final String? selectedShopId;

  const MapLoaded({
    required this.mapEntity,
    required this.currentFloor,
    required this.shops,
    this.selectedShopId,
  });

  @override
  List<Object?> get props => [mapEntity, currentFloor, shops, selectedShopId];

  MapLoaded copyWith({
    MapEntity? mapEntity,
    FloorEntity? currentFloor,
    List<ShopEntity>? shops,
    String? selectedShopId,
  }) {
    return MapLoaded(
      mapEntity: mapEntity ?? this.mapEntity,
      currentFloor: currentFloor ?? this.currentFloor,
      shops: shops ?? this.shops,
      selectedShopId: selectedShopId ?? this.selectedShopId,
    );
  }
}

class MapError extends MapState {
  final String errorMessage;

  const MapError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

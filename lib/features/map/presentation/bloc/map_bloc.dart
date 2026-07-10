import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;

  MapBloc({required this.mapRepository}) : super(const MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<SelectShop>(_onSelectShop);
    on<ClearSelection>(_onClearSelection);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    try {
      final mapData = await mapRepository.getMapData();
      if (mapData.floors.isEmpty) {
        emit(const MapError('No floors found in map data.'));
        return;
      }
      final currentFloor = mapData.floors.first;
      emit(
        MapLoaded(
          mapEntity: mapData,
          currentFloor: currentFloor,
          shops: currentFloor.shops,
        ),
      );
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onSelectShop(SelectShop event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(currentState.copyWith(selectedShopId: event.shopId));
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(
        MapLoaded(
          mapEntity: currentState.mapEntity,
          currentFloor: currentState.currentFloor,
          shops: currentState.shops,
          selectedShopId: null,
        ),
      );
    }
  }
}

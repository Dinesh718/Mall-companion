import 'package:equatable/equatable.dart';
import '../../domain/entities/position_entities.dart';

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

class SearchShops extends MapEvent {
  final String query;

  const SearchShops(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends MapEvent {
  const ClearSearch();
}

class CalculateRoute extends MapEvent {
  final String? startNodeId;
  final String endNodeId;

  const CalculateRoute({this.startNodeId, required this.endNodeId});

  @override
  List<Object?> get props => [startNodeId, endNodeId];
}

class ClearRoute extends MapEvent {
  const ClearRoute();
}

class StartNavigation extends MapEvent {
  const StartNavigation();
}

class AdvanceToNextSegment extends MapEvent {
  const AdvanceToNextSegment();
}

class CompleteFloorTransition extends MapEvent {
  const CompleteFloorTransition();
}

class CancelNavigation extends MapEvent {
  const CancelNavigation();
}

class StartPositioning extends MapEvent {
  const StartPositioning();
}

class StopPositioning extends MapEvent {
  const StopPositioning();
}

class UpdateUserPosition extends MapEvent {
  final IndoorPositionEntity position;

  const UpdateUserPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class SelectFloor extends MapEvent {
  final String floorId;

  const SelectFloor(this.floorId);

  @override
  List<Object?> get props => [floorId];
}

class ToggleVoiceGuidance extends MapEvent {
  const ToggleVoiceGuidance();
}

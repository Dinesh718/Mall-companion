import 'package:equatable/equatable.dart';
import '../../domain/entities/position_entities.dart';
import '../../domain/entities/shop_category.dart';

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

class LoadCategories extends MapEvent {
  const LoadCategories();
}

class SelectCategory extends MapEvent {
  final ShopCategory category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ClearCategory extends MapEvent {
  const ClearCategory();
}

class ScanQrPositionRequested extends MapEvent {
  final String qrId;

  const ScanQrPositionRequested(this.qrId);

  @override
  List<Object?> get props => [qrId];
}

class ClearQrError extends MapEvent {
  const ClearQrError();
}

class NavigationCompleted extends MapEvent {
  const NavigationCompleted();
}

class DestinationSwitchRequested extends MapEvent {
  final String newDestinationShopId;

  const DestinationSwitchRequested(this.newDestinationShopId);

  @override
  List<Object?> get props => [newDestinationShopId];
}

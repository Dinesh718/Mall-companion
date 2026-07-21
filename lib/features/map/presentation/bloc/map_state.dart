import 'package:equatable/equatable.dart';
import '../../domain/entities/map_entities.dart';
import '../../domain/entities/position_entities.dart';
import '../../domain/entities/navigation_instruction_entity.dart';
import '../../domain/entities/route_preview_entities.dart';

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
  final List<ShopEntity>? searchResults;
  final String? searchQuery;
  final NavigationRouteEntity? activeRoute;
  final NavigationSessionEntity? navigationSession;
  final IndoorPositionEntity? latestPosition;
  final List<NavigationInstructionEntity>? instructions;
  final NavigationPreviewEntity? preview;
  final bool isPreviewMode;
  final bool isVoiceMuted;

  const MapLoaded({
    required this.mapEntity,
    required this.currentFloor,
    required this.shops,
    this.selectedShopId,
    this.searchResults,
    this.searchQuery,
    this.activeRoute,
    this.navigationSession,
    this.latestPosition,
    this.instructions,
    this.preview,
    this.isPreviewMode = false,
    this.isVoiceMuted = false,
  });

  @override
  List<Object?> get props => [
    mapEntity,
    currentFloor,
    shops,
    selectedShopId,
    searchResults,
    searchQuery,
    activeRoute,
    navigationSession,
    latestPosition,
    instructions,
    preview,
    isPreviewMode,
    isVoiceMuted,
  ];

  MapLoaded copyWith({
    MapEntity? mapEntity,
    FloorEntity? currentFloor,
    List<ShopEntity>? shops,
    String? selectedShopId,
    List<ShopEntity>? searchResults,
    String? searchQuery,
    NavigationRouteEntity? activeRoute,
    NavigationSessionEntity? navigationSession,
    IndoorPositionEntity? latestPosition,
    List<NavigationInstructionEntity>? instructions,
    NavigationPreviewEntity? preview,
    bool? isPreviewMode,
    bool? isVoiceMuted,
  }) {
    return MapLoaded(
      mapEntity: mapEntity ?? this.mapEntity,
      currentFloor: currentFloor ?? this.currentFloor,
      shops: shops ?? this.shops,
      selectedShopId: selectedShopId ?? this.selectedShopId,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      activeRoute: activeRoute ?? this.activeRoute,
      navigationSession: navigationSession ?? this.navigationSession,
      latestPosition: latestPosition ?? this.latestPosition,
      instructions: instructions ?? this.instructions,
      preview: preview ?? this.preview,
      isPreviewMode: isPreviewMode ?? this.isPreviewMode,
      isVoiceMuted: isVoiceMuted ?? this.isVoiceMuted,
    );
  }
}

class MapError extends MapState {
  final String errorMessage;

  const MapError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

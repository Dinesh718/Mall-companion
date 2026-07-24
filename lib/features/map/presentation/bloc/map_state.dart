import 'package:equatable/equatable.dart';
import '../../domain/entities/map_entities.dart';
import '../../domain/entities/position_entities.dart';
import '../../domain/entities/navigation_instruction_entity.dart';
import '../../domain/entities/route_preview_entities.dart';
import '../../domain/entities/shop_category.dart';
import 'package:visitor_mall/features/navigation/domain/entities/navigation_lifecycle_entity.dart';
import 'package:visitor_mall/features/navigation/domain/entities/active_position_source_entity.dart';

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
  final List<ShopCategory> categories;
  final ShopCategory? selectedCategory;
  final String? qrError;
  final NavigationLifecycleState navigationLifecycleState;
  final PositionSourceType? activePositionSource;

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
    this.categories = const [],
    this.selectedCategory,
    this.qrError,
    this.navigationLifecycleState = NavigationLifecycleState.idle,
    this.activePositionSource,
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
    categories,
    selectedCategory,
    qrError,
    navigationLifecycleState,
    activePositionSource,
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
    List<ShopCategory>? categories,
    ShopCategory? selectedCategory,
    String? qrError,
    bool clearQrError = false,
    NavigationLifecycleState? navigationLifecycleState,
    PositionSourceType? activePositionSource,
    bool clearActivePositionSource = false,
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
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      qrError: clearQrError ? null : (qrError ?? this.qrError),
      navigationLifecycleState:
          navigationLifecycleState ?? this.navigationLifecycleState,
      activePositionSource: clearActivePositionSource
          ? null
          : (activePositionSource ?? this.activePositionSource),
    );
  }

  List<ShopEntity> get displayedShops {
    if (selectedCategory == null &&
        (searchQuery == null || searchQuery!.trim().isEmpty)) {
      return shops;
    }
    final results = searchResults ?? [];
    return results.where((s) => shops.any((fs) => fs.id == s.id)).toList();
  }
}

class MapError extends MapState {
  final String errorMessage;

  const MapError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

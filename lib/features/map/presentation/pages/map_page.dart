import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/local_map_datasource.dart';
import '../../data/repositories/dummy_map_repository.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../../data/datasources/simulation_position_provider.dart';
import '../../data/repositories/position_repository_impl.dart';
import '../../domain/entities/map_entities.dart';
import '../../domain/entities/position_entities.dart';
import '../widgets/indoor_map_view.dart';
import '../widgets/map_controls.dart';
import '../widgets/shop_details_bottom_sheet.dart';
import '../widgets/shop_search_bar.dart';
import '../widgets/shop_search_results.dart';
import '../widgets/elevator_transition_overlay.dart';
import '../helpers/map_camera_controller.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        mapRepository: DummyMapRepository(
          localDataSource: LocalMapDataSourceImpl(
            assetBundle: DefaultAssetBundle.of(context),
          ),
        ),
        positionRepository: PositionRepositoryImpl(
          SimulationPositionProvider(),
        ),
      )..add(const LoadMap()),
      child: const Scaffold(
        backgroundColor: Color(0xFFFEF7FF), // Surface background color
        body: MapPageBody(),
      ),
    );
  }
}

class MapPageBody extends StatefulWidget {
  const MapPageBody({super.key});

  @override
  State<MapPageBody> createState() => _MapPageBodyState();
}

class _MapPageBodyState extends State<MapPageBody>
    with TickerProviderStateMixin {
  static const bool kDebugNavigationTools = true;
  late final TransformationController _transformationController;
  late final MapCameraController _cameraController;
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _cameraController = MapCameraController(
      transformationController: _transformationController,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final currentMatrix = _transformationController.value;
    final scale = currentMatrix.getMaxScaleOnAxis();
    if (scale < 4.0) {
      final newScale = (scale * 1.3).clamp(0.2, 4.0);
      _applyScale(newScale);
    }
  }

  void _zoomOut() {
    final currentMatrix = _transformationController.value;
    final scale = currentMatrix.getMaxScaleOnAxis();
    if (scale > 0.2) {
      final newScale = (scale / 1.3).clamp(0.2, 4.0);
      _applyScale(newScale);
    }
  }

  void _applyScale(double newScale) {
    setState(() {
      final currentMatrix = _transformationController.value;
      final translation = currentMatrix.getTranslation();
      _transformationController.value = Matrix4.identity()
        ..translate(translation.x, translation.y)
        ..scale(newScale);
    });
  }

  void _resetView() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  void _centerMap() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: (previous, current) {
        if (previous is MapLoaded && current is MapLoaded) {
          return previous.selectedShopId != current.selectedShopId;
        }
        return current is MapLoaded;
      },
      listener: (context, state) {
        if (state is MapLoaded) {
          final selectedShopId = state.selectedShopId;
          final shops = state.shops;

          if (selectedShopId != null) {
            ShopEntity? selectedShop;
            for (final shop in shops) {
              if (shop.id == selectedShopId) {
                selectedShop = shop;
                break;
              }
            }

            if (selectedShop != null) {
              // Smoothly animate the camera to the selected shop coordinates
              final viewportSize = MediaQuery.of(context).size;
              _cameraController.animateToGeometry(
                selectedShop.geometry,
                viewportSize,
              );

              if (!_isBottomSheetOpen) {
                _isBottomSheetOpen = true;
                final mapBloc = context.read<MapBloc>();

                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (sheetContext) => ShopDetailsBottomSheet(
                    shop: selectedShop!,
                    floorName: state.currentFloor.name,
                    onNavigate: selectedShop.entranceNodeIds.isNotEmpty
                        ? () {
                            mapBloc.add(
                              CalculateRoute(
                                endNodeId: selectedShop!.entranceNodeIds.first,
                              ),
                            );
                          }
                        : null,
                  ),
                ).then((_) {
                  _isBottomSheetOpen = false;
                  // Clear selection in Bloc if user dismissed the bottom sheet manually
                  if (mounted) {
                    final currentBlocState = mapBloc.state;
                    if (currentBlocState is MapLoaded &&
                        currentBlocState.selectedShopId != null) {
                      mapBloc.add(const ClearSelection());
                    }
                  }
                });
              }
            }
          } else if (selectedShopId == null && _isBottomSheetOpen) {
            // Dismiss programmatically if selection is cleared outside
            _isBottomSheetOpen = false;
            Navigator.pop(context);
          }
        }
      },
      buildWhen: (previous, current) {
        // Do not rebuild parent MapPageBody when only selectedShopId changes
        if (previous.runtimeType != current.runtimeType) return true;
        if (previous is MapLoaded && current is MapLoaded) {
          return previous.currentFloor != current.currentFloor ||
              previous.shops != current.shops;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MapLoading || state is MapInitial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
            ),
          );
        }

        if (state is MapError) {
          return Center(
            child: Text(
              'Error loading map: ${state.errorMessage}',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final loadedState = state as MapLoaded;

        return SafeArea(
          child: Stack(
            children: [
              // 1. Static Indoor map viewport
              IndoorMapView(
                transformationController: _transformationController,
                shops: loadedState.shops,
                svgPath: loadedState.currentFloor.svgPath,
                navigationGraph: loadedState.currentFloor.navigationGraph,
              ),

              // 2. Floating action controls overlay
              MapControls(
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onReset: _resetView,
                onCenter: _centerMap,
              ),

              // 3. Floating search layer
              const Positioned(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [ShopSearchBar(), ShopSearchResults()],
                ),
              ),

              // 4. Floating navigation panel overlay
              if (loadedState.navigationSession != null)
                Positioned(
                  bottom: 24.0,
                  left: 24.0,
                  right: 88.0,
                  child: NavigationPanel(
                    session: loadedState.navigationSession!,
                    shops: loadedState.mapEntity.floors.expand((f) => f.shops).toList(),
                    onCancel: () {
                      context.read<MapBloc>().add(const ClearRoute());
                    },
                  ),
                ),

              // 5. Floor Selector overlay
              Positioned(
                left: 16.0,
                bottom: loadedState.navigationSession != null ? 120.0 : 24.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: loadedState.mapEntity.floors.map((floor) {
                    final isSelected = floor.id == loadedState.currentFloor.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FloatingActionButton.small(
                        heroTag: 'floor_btn_${floor.id}',
                        backgroundColor: isSelected
                            ? const Color(0xFF6100D6)
                            : const Color(0xFFFEF7FF),
                        foregroundColor: isSelected
                            ? Colors.white
                            : const Color(0xFF6100D6),
                        onPressed: () {
                          context.read<MapBloc>().add(SelectFloor(floor.id));
                        },
                        child: Text(
                          floor.id == 'ground_floor' ? 'G' : '1',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // 6. Temporary Debug Recalculation Tools
              if (kDebugNavigationTools)
                Positioned(
                  top: 100.0,
                  right: 24.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'debug_ground_jump_btn',
                        onPressed: () {
                          context.read<MapBloc>().add(
                            UpdateUserPosition(
                              IndoorPositionEntity(
                                id: 'debug_pos_ground',
                                floorId: 'ground_floor',
                                x: 300.0,
                                y: 700.0,
                                accuracy: 1.0,
                                timestamp: DateTime.now(),
                                source: PositionSource.simulation,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.developer_mode),
                        label: const Text('Ground Jump'),
                        backgroundColor: const Color(0xFFFFD8E4),
                        foregroundColor: const Color(0xFF6100D6),
                      ),
                      const SizedBox(height: 8.0),
                      FloatingActionButton.extended(
                        heroTag: 'debug_first_jump_btn',
                        onPressed: () {
                          context.read<MapBloc>().add(
                            UpdateUserPosition(
                              IndoorPositionEntity(
                                id: 'debug_pos_first',
                                floorId: 'first_floor',
                                x: 900.0,
                                y: 350.0,
                                accuracy: 1.0,
                                timestamp: DateTime.now(),
                                source: PositionSource.simulation,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.developer_mode),
                        label: const Text('First Floor Jump'),
                        backgroundColor: const Color(0xFFFFD8E4),
                        foregroundColor: const Color(0xFF6100D6),
                      ),
                    ],
                  ),
                ),
              const ElevatorTransitionOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class NavigationPanel extends StatelessWidget {
  final NavigationSessionEntity session;
  final List<ShopEntity> shops;
  final VoidCallback onCancel;

  const NavigationPanel({
    super.key,
    required this.session,
    required this.shops,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final destinationShop = shops.firstWhere(
      (s) => s.id == session.destinationShopId,
      orElse: () => shops.first,
    );

    String statusText = 'Navigating to ${destinationShop.name}';
    IconData statusIcon = Icons.directions_walk_outlined;
    Color iconColor = const Color(0xFF6100D6);

    if (session.navigationStatus == NavigationStatus.arrived) {
      statusText = 'Arrived at ${destinationShop.name}!';
      statusIcon = Icons.check_circle_outline;
      iconColor = const Color(0xFF2E7D32);
    } else if (session.navigationStatus ==
        NavigationStatus.waitingForConnector) {
      statusText = 'Connector reached. Proceed to next floor.';
      statusIcon = Icons.import_export_outlined;
      iconColor = const Color(0xFFFFB300);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF), // Surface background color
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: iconColor, size: 24.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  session.navigationStatus == NavigationStatus.arrived
                      ? 'Destination reached'
                      : 'Remaining: ${session.remainingDistance.toStringAsFixed(1)} m',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4456),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF4A4456)),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

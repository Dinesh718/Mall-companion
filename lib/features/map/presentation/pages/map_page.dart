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
import '../../domain/entities/navigation_instruction_entity.dart';
import '../widgets/indoor_map_view.dart';
import '../widgets/map_controls.dart';
import '../widgets/shop_details_bottom_sheet.dart';
import '../widgets/shop_search_bar.dart';
import '../widgets/shop_search_results.dart';
import '../widgets/elevator_transition_overlay.dart';
import '../widgets/route_preview_card.dart';
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
                            if (_isBottomSheetOpen) {
                              _isBottomSheetOpen = false;
                              Navigator.of(sheetContext).pop();
                            }
                            mapBloc.add(
                              CalculateRoute(
                                endNodeId: selectedShop!.entranceNodeIds.first,
                              ),
                            );
                            mapBloc.add(const StartNavigation());
                          }
                        : null,
                  ),
                ).then((_) {
                  _isBottomSheetOpen = false;
                });
              }
            }
          }
        }
      },
      buildWhen: (previous, current) {
        // Rebuild parent MapPageBody when floor, shops, activeRoute, navigationSession, instructions, or preview mode changes
        if (previous.runtimeType != current.runtimeType) return true;
        if (previous is MapLoaded && current is MapLoaded) {
          return previous.currentFloor != current.currentFloor ||
              previous.shops != current.shops ||
              previous.activeRoute != current.activeRoute ||
              previous.navigationSession != current.navigationSession ||
              previous.instructions != current.instructions ||
              previous.preview != current.preview ||
              previous.isPreviewMode != current.isPreviewMode ||
              previous.latestPosition != current.latestPosition;
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

        debugPrint("==================================");
debugPrint("isPreviewMode : ${loadedState.isPreviewMode}");
debugPrint("navigationSession : ${loadedState.navigationSession != null}");
debugPrint("preview : ${loadedState.preview != null}");
debugPrint("currentFloor : ${loadedState.currentFloor.id}");
debugPrint("==================================");

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

              // 4. Route Preview Card overlay
              if (loadedState.isPreviewMode && loadedState.preview != null)
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: RoutePreviewCard(
                    preview: loadedState.preview!,
                    onStartNavigation: () {
                      context.read<MapBloc>().add(const StartNavigation());
                    },
                    onClose: () {
                      context.read<MapBloc>().add(const ClearRoute());
                    },
                  ),
                ),

              // 5. Floating navigation panel and instruction banner overlay
              if (!loadedState.isPreviewMode && loadedState.navigationSession != null)
                Positioned(
                  bottom: 24.0,
                  left: 24.0,
                  right: 88.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (loadedState.instructions != null && loadedState.instructions!.isNotEmpty) ...[
                        NavigationInstructionBanner(
                          instruction: loadedState.instructions!.firstWhere(
                            (inst) => !inst.isCompleted,
                            orElse: () => loadedState.instructions!.last,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                      NavigationPanel(
                        session: loadedState.navigationSession!,
                        shops: loadedState.mapEntity.floors.expand((f) => f.shops).toList(),
                        onCancel: () {
                          context.read<MapBloc>().add(const ClearRoute());
                        },
                      ),
                    ],
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
          BlocBuilder<MapBloc, MapState>(
            buildWhen: (previous, current) {
              if (previous is! MapLoaded || current is! MapLoaded) return true;
              return previous.isVoiceMuted != current.isVoiceMuted;
            },
            builder: (context, state) {
              final isMuted = state is MapLoaded && state.isVoiceMuted;
              return IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                  color: const Color(0xFF6100D6),
                ),
                tooltip: isMuted ? 'Unmute Voice Guidance' : 'Mute Voice Guidance',
                onPressed: () {
                  context.read<MapBloc>().add(const ToggleVoiceGuidance());
                },
              );
            },
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

class NavigationInstructionBanner extends StatelessWidget {
  final NavigationInstructionEntity instruction;

  const NavigationInstructionBanner({super.key, required this.instruction});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'straight':
        return Icons.arrow_upward;
      case 'slightLeft':
        return Icons.turn_slight_left;
      case 'left':
        return Icons.turn_left;
      case 'sharpLeft':
        return Icons.turn_sharp_left;
      case 'slightRight':
        return Icons.turn_slight_right;
      case 'right':
        return Icons.turn_right;
      case 'sharpRight':
        return Icons.turn_sharp_right;
      case 'lift':
        return Icons.elevator_outlined;
      case 'stairs':
        return Icons.stairs_outlined;
      case 'escalator':
        return Icons.escalator_outlined;
      case 'arrival':
        return Icons.pin_drop_outlined;
      default:
        return Icons.navigation_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData icon = _getIconForType(instruction.type);
    const Color themeColor = Color(0xFF6100D6);

    final showDistance = instruction.type == 'straight' && instruction.distanceRemaining > 0;
    final distanceText = showDistance
        ? '${instruction.distanceRemaining.toStringAsFixed(0)} m remaining'
        : '';

    final isConnector = instruction.type == 'lift' ||
                        instruction.type == 'stairs' ||
                        instruction.type == 'escalator';

    final titleText = isConnector
        ? '${instruction.type.toUpperCase()} AHEAD'
        : 'WALK DIRECTION';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEADDFF),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF6100D6).withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: themeColor, size: 20.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  instruction.text,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1A25),
                  ),
                ),
                if (showDistance) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    distanceText,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/local_map_datasource.dart';
import '../../data/repositories/dummy_map_repository.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/indoor_map_view.dart';
import '../widgets/map_controls.dart';
import '../widgets/shop_details_bottom_sheet.dart';

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

class _MapPageBodyState extends State<MapPageBody> {
  late final TransformationController _transformationController;
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
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

          if (selectedShopId != null && !_isBottomSheetOpen) {
            final selectedShop = shops.firstWhere(
              (s) => s.id == selectedShopId,
            );
            _isBottomSheetOpen = true;
            final mapBloc = context.read<MapBloc>();

            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (sheetContext) => ShopDetailsBottomSheet(
                shop: selectedShop,
                floorName: state.currentFloor.name,
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
              ),

              // 2. Floating action controls overlay
              MapControls(
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onReset: _resetView,
                onCenter: _centerMap,
              ),
            ],
          ),
        );
      },
    );
  }
}

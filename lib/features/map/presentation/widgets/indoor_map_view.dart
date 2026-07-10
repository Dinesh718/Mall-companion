import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/map_entities.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';
import 'map_interaction_layer.dart';
import 'shop_highlight_layer.dart';

class IndoorMapView extends StatelessWidget {
  final TransformationController transformationController;
  final List<ShopEntity> shops;
  final String svgPath;

  const IndoorMapView({
    super.key,
    required this.transformationController,
    required this.shops,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: InteractiveViewer(
            transformationController: transformationController,
            minScale: 0.2,
            maxScale: 4.0,
            boundaryMargin: const EdgeInsets.all(500.0),
            clipBehavior: Clip.none,
            constrained: false,
            child: SizedBox(
              width: 1536.0,
              height: 838.0,
              child: Stack(
                children: [
                  // 1. Background PNG Blueprint layer
                  Image.asset(
                    'assets/images/maps/ground_floor_visual.png',
                    width: 1536.0,
                    height: 838.0,
                    fit: BoxFit.fill,
                  ),

                  // 2. Translucent SVG Overlay layer (direct viewBox overlay alignment)
                  Opacity(
                    opacity: 0.25,
                    child: SvgPicture.asset(
                      svgPath,
                      width: 1536.0,
                      height: 838.0,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // 3. Highlight Overlay layer (rebuilds ONLY when active shop selection changes)
                  BlocSelector<MapBloc, MapState, ShopEntity?>(
                    selector: (state) {
                      if (state is MapLoaded && state.selectedShopId != null) {
                        try {
                          return state.shops.firstWhere(
                            (s) => s.id == state.selectedShopId,
                          );
                        } catch (_) {
                          return null;
                        }
                      }
                      return null;
                    },
                    builder: (context, selectedShop) {
                      return ShopHighlightLayer(
                        selectedShop: selectedShop,
                        width: 1536.0,
                        height: 838.0,
                      );
                    },
                  ),

                  // 4. Invisible touch hit testing layer (aligned 1-to-1 to canvas coordinates)
                  MapInteractionLayer(
                    shops: shops,
                    width: 1536.0,
                    height: 838.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

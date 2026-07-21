import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/map_entities.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';
import 'map_interaction_layer.dart';
import 'navigation_graph_debug_layer.dart';
import 'route_layer.dart';
import 'shop_highlight_layer.dart';
import 'user_position_layer.dart';

class IndoorMapView extends StatelessWidget {
  final TransformationController transformationController;
  final List<ShopEntity> shops;
  final String svgPath;
  final NavigationGraphEntity navigationGraph;

  const IndoorMapView({
    super.key,
    required this.transformationController,
    required this.shops,
    required this.svgPath,
    required this.navigationGraph,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("=================================");
debugPrint("INDOOR MAP BUILD");
debugPrint("svgPath = $svgPath");
debugPrint("shops = ${shops.length}");
debugPrint("graph nodes = ${navigationGraph.nodes.length}");
debugPrint("=================================");
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
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 1536.0,
                height: 838.0,
                child: Stack(
                  children: [
                    // 1. Background PNG Blueprint layer
                    if (svgPath.contains('ground_floor'))
                      Image.asset(
                        'assets/images/maps/ground_floor_visual.png',
                        width: 1536.0,
                        height: 838.0,
                        fit: BoxFit.fill,
                      )
                    else if (svgPath.contains('first_floor'))
                      Image.asset(
                        'assets/images/maps/first_floor_visual.png',
                        width: 1536.0,
                        height: 838.0,
                        fit: BoxFit.fill,
                      )
                    else
                      Container(
                        color: Colors.white,
                        width: 1536.0,
                        height: 838.0,
                      ),

                    // 2. SVG Overlay layer (use 0.25 opacity for both floors to see blueprint detail)
                    Opacity(
                      opacity: 0.25,
                      child: SvgPicture.asset(
                        svgPath,
                        width: 1536.0,
                        height: 838.0,
                        fit: BoxFit.fill,
                      ),
                    ),

                    // 2.5. Navigation Graph Debug Layer
                    NavigationGraphDebugLayer(
                      navigationGraph: navigationGraph,
                      width: 1536.0,
                      height: 838.0,
                    ),

                    // 2.7. Route Rendering Layer (rebuilds ONLY when activeRoute changes)
                    BlocSelector<
                      MapBloc,
                      MapState,
                      List<NavigationNodeEntity>?
                    >(
                      selector: (state) {
                        if (state is MapLoaded && state.activeRoute != null) {
                          return state.activeRoute!.completeRoute;
                        }
                        return null;
                      },
                      builder: (context, activeRoute) {
                        return RouteLayer(
                          activeRoute: activeRoute,
                          currentFloorId: svgPath.contains('ground_floor') ? 'ground_floor' : 'first_floor',
                          width: 1536.0,
                          height: 838.0,
                        );
                      },
                    ),

                    // 3. Highlight Overlay layer (rebuilds ONLY when active shop selection changes)
                    BlocSelector<MapBloc, MapState, ShopEntity?>(
                      selector: (state) {
                        if (state is MapLoaded &&
                            state.selectedShopId != null) {
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

                    // 3.5. User Position Overlay Layer
                    UserPositionLayer(
                      width: 1536.0,
                      height: 838.0,
                      transformationController: transformationController,
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
          ),
        );
      },
    );
  }
}

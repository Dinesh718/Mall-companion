import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/map_entities.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';

class MapInteractionLayer extends StatelessWidget {
  final List<ShopEntity> shops;
  final double width;
  final double height;

  const MapInteractionLayer({
    super.key,
    required this.shops,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (details) {
        final localOffset = details.localPosition;
        final point = Point2D(localOffset.dx, localOffset.dy);
        debugPrint(
          '--- TAP OCCURRED AT COORDINATE: (${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)}) ---',
        );

        // Check top-most shop first in case of overlapping regions
        for (int i = shops.length - 1; i >= 0; i--) {
          final shop = shops[i];
          // Corridors and escalators are map geometry only, not interactive shops
          if (shop.category == 'Corridor' || shop.category == 'Escalator') {
            continue;
          }
          final containsPoint = shop.geometry.contains(point);
          if (containsPoint) {
            debugPrint('>>> MATCH FOUND: ${shop.name} (${shop.id})');
            context.read<MapBloc>().add(SelectShop(shop.id));
            return;
          }
        }

        debugPrint('>>> NO MATCH: Tapped outside all shops');
        final mapBloc = context.read<MapBloc>();
        mapBloc.add(const ClearSelection());
        mapBloc.add(const ClearRoute());
      },
      child: Container(
        width: width,
        height: height,
        color:
            Colors.transparent, // Capture tap events across the full map bounds
      ),
    );
  }
}

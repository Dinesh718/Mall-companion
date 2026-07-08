import 'package:flutter/material.dart';
import '../../domain/entities/brand_entities.dart';

class BrandStoreCard extends StatelessWidget {
  final BrandStoreEntity store;
  final VoidCallback onNavigateTap;
  final bool isPrimaryStyle;

  const BrandStoreCard({
    super.key,
    required this.store,
    required this.onNavigateTap,
    this.isPrimaryStyle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.layers_rounded,
                          color: Color(0xFF7B7488),
                          size: 14.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          store.levelText,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            color: Color(0xFF7B7488),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F9EC),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  store.statusText.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B723A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            store.openHours,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.0,
              color: Color(0xFF4A4456),
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            store.descriptionText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11.0,
              fontStyle: FontStyle.italic,
              color: Color(0xFF7B7488),
            ),
          ),
          const SizedBox(height: 24.0),
          GestureDetector(
            onTap: onNavigateTap,
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(
                gradient: isPrimaryStyle
                    ? const LinearGradient(
                        colors: [Color(0xFF6100D6), Color(0xFF2170E4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isPrimaryStyle ? null : const Color(0xFFF3EBFA),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: isPrimaryStyle
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6100D6).withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    color: isPrimaryStyle
                        ? Colors.white
                        : const Color(0xFF6100D6),
                    size: 18.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Navigate',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: isPrimaryStyle
                          ? Colors.white
                          : const Color(0xFF6100D6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

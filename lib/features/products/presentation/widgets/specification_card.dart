import 'package:flutter/material.dart';
import '../../domain/entities/product_entities.dart';

class SpecificationCard extends StatelessWidget {
  final List<SpecificationEntity> specifications;

  const SpecificationCard({
    super.key,
    required this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    if (specifications.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: const Color(0xFFCCC3D9).withAlpha(76), // outline-variant/30
            width: 1.0,
          ),
        ),
        child: Column(
          children: List.generate(specifications.length, (index) {
            final spec = specifications[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == specifications.length - 1 ? 0 : 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    spec.key,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      color: Color(0xFF7B7488), // outline
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    spec.value,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      color: Color(0xFF1D1A25), // on-surface
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

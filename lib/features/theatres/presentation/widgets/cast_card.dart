import 'package:flutter/material.dart';
import '../../domain/entities/theatre_entities.dart';

class CastCard extends StatelessWidget {
  final CastMemberEntity castMember;

  const CastCard({
    super.key,
    required this.castMember,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.0,
      child: Column(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(castMember.imageUrl),
                fit: BoxFit.cover,
                onError: (_, __) {},
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            castMember.name,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0,
              fontWeight: FontWeight.w600, // card-title size
              color: Color(0xFF1D1A25), // on-surface
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            castMember.characterName,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A4456), // on-surface-variant
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

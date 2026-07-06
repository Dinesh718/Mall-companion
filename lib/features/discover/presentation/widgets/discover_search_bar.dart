import 'package:flutter/material.dart';

class DiscoverSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final String currentQuery;

  const DiscoverSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.currentQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Search Bar Input Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 56.0,
            decoration: BoxDecoration(
              color: Colors.white, // surface-container-lowest
              borderRadius: BorderRadius.circular(12.0), // rounded-xl
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.search_outlined,
                  color: Color(0xFF7B7488), // outline
                  size: 24.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search for stores, brands, products...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7B7488),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D1A25),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Voice mic action
                      },
                      icon: const Icon(
                        Icons.mic_outlined,
                        color: Color(0xFF6100D6), // primary
                        size: 22.0,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                    ),
                    const SizedBox(width: 12.0),
                    IconButton(
                      onPressed: () {
                        // QR scan action
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner_outlined,
                        color: Color(0xFF6100D6), // primary
                        size: 22.0,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        // 2. Horizontal AI Suggestion Chips List
        SizedBox(
          height: 38.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              _buildSuggestionChip('Find Nike shoes'),
              _buildSuggestionChip('Nearest washroom'),
              _buildSuggestionChip('Food court offers'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE5F5), // surface-container-high
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3), // outline-variant/30
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100.0),
        child: InkWell(
          onTap: () {
            // Apply chip text to search query
            onSearchChanged(text);
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  size: 16.0,
                  color: Color(0xFF6100D6), // primary
                ),
                const SizedBox(width: 6.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

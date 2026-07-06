import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 56.0,
        decoration: BoxDecoration(
          color: const Color(0xFFEDE5F5), // surface-container-high
          borderRadius: BorderRadius.circular(
            16.0,
          ), // rounded corner radius (12-16px)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: Color(0xFF4A4456), // on-surface-variant
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search stores, brands or ask...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0x994A4456),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
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
                    // QR Scanner action
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF4A4456),
                    size: 22.0,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20.0,
                ),
                const SizedBox(width: 12.0),
                IconButton(
                  onPressed: () {
                    // Voice search action
                  },
                  icon: const Icon(
                    Icons.mic_none_outlined,
                    color: Color(0xFF4A4456),
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
    );
  }
}

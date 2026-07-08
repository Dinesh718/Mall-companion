import 'package:flutter/material.dart';

class ParkingMapCard extends StatelessWidget {
  final String levelText;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFullscreen;

  const ParkingMapCard({
    super.key,
    required this.levelText,
    this.onZoomIn,
    this.onZoomOut,
    this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EBFA), // surface-container
        borderRadius: BorderRadius.circular(28.0), // rounded-xxl (28px)
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.5), // outline-variant/50
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Simulated Grid/Dots blueprint layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCp1-c2HtY84u_rVroXEQaL8XwPgbgluSvSvhQvilfdaq6H7vF5Y79wIlaPxAqoyrEcA4jStnYK2A8acjTmhmQjQOONeNDDH_yh5tjjSYOxqGHbSym5k6vybqDVGwBW01zTmBYrMyfDVfcVbfj6jmBu0F-GkQPUxChG2Gcr-UkTu74wI3zm2-0oLFUzcwHL8SViEJMRLuYtyOTjTnbMZQ4erWPmGM-DU2wxKOF00r1TduNYImD3dLiwK79MuTbZDMF50RKrCX_dm_M',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Map mockup details
          const Center(
            child: Opacity(
              opacity: 0.6,
              child: Icon(
                Icons.map_outlined,
                size: 80.0,
                color: Color(0xFF6100D6),
              ),
            ),
          ),

          // Zoom control buttons (Top-Right overlay)
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: onZoomIn,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: onZoomOut,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.remove_rounded,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fullscreen button (Top-Left overlay)
          Positioned(
            top: 16.0,
            left: 16.0,
            child: GestureDetector(
              onTap: onFullscreen,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fullscreen_rounded,
                  color: Color(0xFF4A4456),
                ),
              ),
            ),
          ),

          // Bottom level guide bar banner
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    levelText,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0, // label-lg
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6100D6), // primary
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color(0xFF6100D6),
                    size: 20.0,
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

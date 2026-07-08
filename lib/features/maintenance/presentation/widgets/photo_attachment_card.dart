import 'package:flutter/material.dart';

class PhotoAttachmentCard extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onRemoveTap;

  const PhotoAttachmentCard({
    super.key,
    required this.photoPath,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    if (hasPhoto) {
      return Container(
        height: 180.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          image: DecorationImage(
            image: NetworkImage(photoPath!),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: 12.0,
              right: 12.0,
              child: GestureDetector(
                onTap: onRemoveTap,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.black38,
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16.0),
                    SizedBox(width: 8.0),
                    Text(
                      'Photo Attached Successfully',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0), // rounded-[28px]
        border: Border.all(
          color: const Color(0xFFCCC3D9), // outline-variant
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: const BoxDecoration(
              color: Color(0xFFEADDFF), // primary-fixed
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.photo_camera,
              color: Color(0xFF6100D6), // primary
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Upload Photos',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30), // on-surface
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Take a clear photo of the issue to help us locate it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF), // surface-container-low
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: Color(0xFF0B1C30), size: 16.0),
                        SizedBox(width: 8.0),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B1C30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: GestureDetector(
                  onTap: onGalleryTap,
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF), // surface-container-low
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, color: Color(0xFF0B1C30), size: 16.0),
                        SizedBox(width: 8.0),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B1C30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

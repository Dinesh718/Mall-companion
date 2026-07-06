import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 176.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: const LinearGradient(
            colors: [Color(0xFF6100D6), Color(0xFF7423F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative blurred blob 1
            Positioned(
              right: -20.0,
              top: -20.0,
              width: 192.0,
              height: 192.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            // Decorative blurred blob 2
            Positioned(
              left: -40.0,
              bottom: -40.0,
              width: 256.0,
              height: 256.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(
                    0xFF7B2FF7,
                  ).withOpacity(0.2), // primary-container
                ),
              ),
            ),
            // Content Row (Left aligned text block + Right aligned image)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Text Block (Left Side)
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weekend Special'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600, // label-sm
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Weekend Bonanza Up To 50% Off',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.0, // headline-md / headline-lg
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () {
                            // Explore offers action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6100D6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 4.0,
                            shadowColor: Colors.black.withOpacity(0.15),
                          ),
                          child: const Text(
                            'Explore Offers',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600, // label-lg
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Space placeholder for the absolute positioned image overlay
                  const Expanded(flex: 2, child: SizedBox.shrink()),
                ],
              ),
            ),
            // Absolute Positioned Vector Image (Right Side)
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              width: MediaQuery.of(context).size.width * 0.38,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBoxRgdGanBZZFj35VLS1naKbuCsniJMt1yTFbQGGKbW-y4euO8kaqh-yJ32azoOXRjWSQjomjlGrKfQBS-h5PhGfkM25MwDTXs3zs8COOc8oDl-iKKcENUIuh9q2RYUeRypDFu20x8v8un-YqeDIg8zDzv4cb-LPBANqaYZWwmjJZ4O_aTh_aOI6_IrvuL161MgGu8CkcCyarp4Ec217q6z63nU5uQn3TCECBL1gZ5nwQCNDK0TLuJLhIdmKHcqFAzW5lpRKKhmA',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

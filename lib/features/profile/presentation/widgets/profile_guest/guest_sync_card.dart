import 'package:flutter/material.dart';

class GuestSyncCard extends StatelessWidget {
  const GuestSyncCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localChips = [
      'English',
      'Light Theme',
      'High Contrast',
      'Recent Searches',
      'Favorite Routes',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Saved Locally Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0), // rounded-card
            border: Border.all(
              color: const Color(
                0xFFCCC3D9,
              ).withOpacity(0.2), // outline-variant/20
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EBFA), // bg-surface-container
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.data_usage,
                      color: Color(0xFF6100D6), // primary
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Locally',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16.0, // title-lg
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25), // on-surface
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          'These preferences are stored only on this device.',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0, // body-md
                            color: Color(0xFF4A4456), // on-surface-variant
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: localChips.map((chip) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EBFA), // bg-surface-container
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: Text(
                      chip,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0, // label-lg
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32.0),
        // 2. Available Offline Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0), // rounded-card
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FF7).withOpacity(0.2),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Decorative circle bottom right
              Positioned(
                right: -32.0,
                bottom: -32.0,
                child: Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Offline',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 22.0, // headline-md
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          const Text(
                            'Carry the mall in your pocket, even without signal.',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13.0, // body-md
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildOfflineBenefitRow(
                            Icons.check_circle,
                            'Mall Directory & Maps',
                          ),
                          const SizedBox(height: 8.0),
                          _buildOfflineBenefitRow(
                            Icons.check_circle,
                            'Emergency Contacts',
                          ),
                          const SizedBox(height: 8.0),
                          _buildOfflineBenefitRow(
                            Icons.check_circle,
                            'Saved Preferences',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Illustration mapping screen.png
                    Container(
                      width: 110.0,
                      height: 110.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDc6feE0bsDZoeKN6CEL0O5i_CEtXcT4oojxwakuAYH6wBesaQyp0OK10gMZELU5bTWITxTE9poEw1cUWyI23eTIKR8qzzdgDi0e3LGtwRJlK2mUEx5syrlAmwWc5rg9pX8MMWa6wrPANAkqrChl34OSrvVnbAKGxUFSltWs8KeRuF2zbNzzm82Z_SqBa_3Nf1GFUGYZdsQmky_JA1QSAzZco6gX1PsiSpF7QTmGOMs-Ki0ePl5IPR44sMTaCGZHvaesZr4ve2CTaY',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18.0),
        const SizedBox(width: 10.0),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13.0, // body-md
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

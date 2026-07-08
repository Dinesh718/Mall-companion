import 'package:flutter/material.dart';

class GuestActivityCard extends StatelessWidget {
  const GuestActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      const _ActivityItem(
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhxqImT5sWJQpRvfvXeCEJcTmxJJOQenMStBDtOFkfmIQpL0w2QcMCk_JPmti2idV5mpqoFdopYrA41Ih755A2tnd0jycDJrJNk0OM11w8Rjqh24K_bCo58Z0nWtX5-J7M13wIlMGou3A2hZVwGxyKJiki3Us-GzSYcrsbINWKhBjFXPi7PQCJ-oA8KY7cv1IymE24jxBMkNApYCZlWPp8fAVTFvCNhD0CrQEOmT_qS-EB7yOtE9dki-3Aic7gvMWx5Pgf9Lezd1A',
        category: 'Navigation',
        title: 'Food Court',
      ),
      const _ActivityItem(
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBfJQmRa8Cs7wTtt-6GmqeUmgg1u1LfdX5myf9u8WWYKQNsdCBgmL7nt8akTbyA71FKi90lr2tPmarLM0yvl1I9J28LgJnCYti6Rc1CMNK66MPk9tIOYxJRD162UMknij-Jmk7kgiyop6PQvHbLIWdaKkWS_n6IwnFN0-NU0K_PtW29HZb4IZ8HkBlZDNI-JAPyY9FmG25RQjiU-iw1FSmEnrYZbJ1MDDDribzClU9FPWo6bMMJ4Zow6HG_gX-oJN8Mt5PvedlR-WQ',
        category: 'Store Visit',
        title: 'Luxe Boutique',
      ),
      const _ActivityItem(
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCK8C8qKD6oRp5dF7iJ3hVGT-2G5LxRcQmBw25_iT2MTBMfA3XILe5D0nf0I1Af8bL7RRPL6FZlU-k1er91dnY6mPSRJa7moAH1Nb41V2zNTbCTlOgYcS0D-CXyur9SQ0D6rbgb-z1EWMjYz0xi6tg2q3EKWW9b_K13a005ct4vRtZq4awVtltEyFE5WHDMUuFITxtqvaaBFEN24roVrWgCGuJ1j2JUlB_KxDAqOgzCgPlUoadjTeATBDROGgrqMUXUirLNvUK-F6k',
        category: 'Search',
        title: 'Coffee Shops',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // headline-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 196.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16.0),
            itemBuilder: (context, index) {
              return activities[index];
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;

  const _ActivityItem({
    required this.imageUrl,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192.0, // w-48
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-card
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
          // AspectRatio container for image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE5F5), // bg-surface-container-high
                borderRadius: BorderRadius.circular(16.0), // rounded-xl
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          // Category Label
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.0, // label-lg
              fontWeight: FontWeight.w600,
              color: Color(0xFF6100D6), // primary
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
        ],
      ),
    );
  }
}

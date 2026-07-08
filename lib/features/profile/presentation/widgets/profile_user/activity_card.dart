import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      const _TransactionItem(
        title: 'Zara Fashion Purchase',
        subtitle: 'Earned at Main Wing Outlet',
        dateText: 'Today, 2:30 PM',
        pointsText: '+150 pts',
        isPositive: true,
      ),
      const _TransactionItem(
        title: 'Starbucks Coffee',
        subtitle: 'Earned at Food Court',
        dateText: 'Yesterday, 10:15 AM',
        pointsText: '+30 pts',
        isPositive: true,
      ),
      const _TransactionItem(
        title: 'Parking Discount Redeemed',
        subtitle: 'Redeemed at Zone P2',
        dateText: '05 July, 6:00 PM',
        pointsText: '-100 pts',
        isPositive: false,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(0xFFF3EBFA), // border-surface-container
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Points History',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18.0, // title-lg
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25), // on-surface
              ),
            ),
          ),
          const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEDE5F5)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0xFFEDE5F5),
              indent: 20.0,
              endIndent: 20.0,
            ),
            itemBuilder: (context, index) {
              return transactions[index];
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateText;
  final String pointsText;
  final bool isPositive;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.pointsText,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color(0xFF0058BE).withOpacity(
                      0.08,
                    ) // positive blue/green tint
                  : const Color(
                      0xFFBA1A1A,
                    ).withOpacity(0.08), // negative red tint
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              isPositive
                  ? Icons.add_circle_outline
                  : Icons.remove_circle_outline,
              color: isPositive
                  ? const Color(0xFF0058BE)
                  : const Color(0xFFBA1A1A),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0, // body-md
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0, // label-md
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  dateText,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.0,
                    color: const Color(0xFF4A4456).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            pointsText,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: isPositive
                  ? const Color(0xFF0058BE)
                  : const Color(0xFFBA1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

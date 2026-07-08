import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entities.dart';

class RestaurantQueueTicketPage extends StatelessWidget {
  final RestaurantEntity restaurant;

  const RestaurantQueueTicketPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Generate simulated ticket data
    final now = DateTime.now();
    final bookingTime = now.add(const Duration(minutes: 5));
    final seatingTime = now.add(const Duration(minutes: 20));

    final timeString = "${bookingTime.hour.toString().padLeft(2, '0')}:${bookingTime.minute.toString().padLeft(2, '0')} PM";
    final seatingString = "${seatingTime.hour.toString().padLeft(2, '0')}:${seatingTime.minute.toString().padLeft(2, '0')} PM";

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // surface-bright
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D1A25), size: 20.0),
        ),
        centerTitle: true,
        title: const Text(
          'Queue Ticket',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6100D6), // primary
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1D1A25)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // 1. Digital Pass Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 30.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE8DFEF).withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    // Header Info Section
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDT8Y9OMKwIjTQJKsEyKKca4LBQUieQTHqOQdZYsMrL7K1AXVVwC9PFwp5Oq4ZtQ2HAmw-tm8jM7mona8SBAjBocVl_ESx8hmoWFojw5WzGjUyK2m5_LcsCaftySTTGx4qylcjGakVscvzQo6YcbtpZyMoxREfBbX56TMp98rMHaNTCS6rWFQqL5H0m7t-BpTV-ARQVK1odetbz76G8u4ECZtFPLlELvqV1-pf1iAptYI4kx7J33_UvPEq2nLDM93thmQOl_8zEug',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D1A25),
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    restaurant.floorText,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12.0,
                                      color: Color(0xFF4A4456),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'QUEUE NO.',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6100D6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                'A-024',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6100D6),
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Perforated Separation Line
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dashed separating painter
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: CustomPaint(
                            size: const Size(double.infinity, 1.0),
                            painter: _DashedLinePainter(),
                          ),
                        ),
                        // Left Circular punch
                        const Positioned(
                          left: -10.0,
                          child: CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Color(0xFFFEF7FF),
                          ),
                        ),
                        // Right Circular punch
                        const Positioned(
                          right: -10.0,
                          child: CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Color(0xFFFEF7FF),
                          ),
                        ),
                      ],
                    ),

                    // QR Code Center Box
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBRCM0xwva3YsBOwfjQmt5AELcTGBgRBP1ObI1IjoksTyF6Jznqme14lzO_3PmHe9yST-RlB_3rEDsfqlw_FaZBFj-mVTM_OS1YBFIyUqqYsOUck7DF5RT9OHfL8ITCmGltAnyaTwSU5uL8v2oGq229fASVcI_-I6r2jRtKtmcDe0D6qPs4YQLUuvZi93Nvh_SJC0_-_lZgLLTGFGslQhVmDdizOGE1VSRPeizMLKu2Rvsx5pHhHx1hSkSkVf2ieUjKFL14hSS5fQ',
                                width: 180.0,
                                height: 180.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Show this QR code at the restaurant entrance to confirm your queue reservation.',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12.0,
                              color: Color(0xFF4A4456),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Ticket details grids
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 2.3,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: [
                          _buildDetailTile('Reservation Time', 'Today, $timeString'),
                          _buildDetailTile(
                            'Estimated Seating',
                            '~ $seatingString',
                            textColor: const Color(0xFF6100D6),
                            isBold: true,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Party Size',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.0,
                                  color: Color(0xFF4A4456),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: const [
                                  Icon(Icons.groups, size: 18.0, color: Color(0xFF4A4456)),
                                  SizedBox(width: 6.0),
                                  Text(
                                    '4 People',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D1A25),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.0,
                                  color: Color(0xFF4A4456),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF6100D6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  const Text(
                                    'Waiting',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6100D6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // 2. Queue Tracker Bento Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE8DFEF).withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Live Tracker',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6100D6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          child: const Text(
                            'Updating Live',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6100D6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    // Grid stats row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F1FF),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Queue Position',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 11.0,
                                    color: Color(0xFF4A4456),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '12',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D1A25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F1FF),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'People Ahead',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 11.0,
                                    color: Color(0xFF4A4456),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '8',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D1A25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Progress indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Preparing Table',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                        Text(
                          'Step 3 of 4',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.0,
                            color: Color(0xFF4A4456),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Gradient Progress bar
                    Container(
                      height: 10.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE5F5),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)],
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    const Center(
                      child: Text(
                        '"We\'re making things ready for your arrival!"',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF4A4456),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),

              // 3. Action Buttons
              Container(
                height: 54.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6100D6).withOpacity(0.2),
                      blurRadius: 15.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.near_me, color: Colors.white, size: 20.0),
                        SizedBox(width: 8.0),
                        Text(
                          'Navigate to Restaurant',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined, size: 18.0),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1D1A25),
                        side: const BorderSide(color: Color(0xFFCCC3D9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        minimumSize: const Size(0, 50.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18.0),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFBA1A1A),
                        side: const BorderSide(color: Color(0xFFCCC3D9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        minimumSize: const Size(0, 50.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value, {Color? textColor, bool isBold = false}) {
    return Column(
      crossAxisAlignment: label.startsWith('Estimated') ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.0,
            color: Color(0xFF4A4456),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14.0,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: textColor ?? const Color(0xFF1D1A25),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCC3D9).withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

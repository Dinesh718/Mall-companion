import 'package:flutter/material.dart';
import '../../../profile/data/datasource/profile_local_datasource.dart';
import '../../domain/entities/maintenance_entities.dart';
import '../widgets/ticket_timeline.dart';
import 'report_issue_page.dart';
import 'my_reports_page.dart';

class TicketCreatedPage extends StatefulWidget {
  final MaintenanceReportEntity ticket;

  const TicketCreatedPage({super.key, required this.ticket});

  @override
  State<TicketCreatedPage> createState() => _TicketCreatedPageState();
}

class _TicketCreatedPageState extends State<TicketCreatedPage> {
  bool _isLoggedIn = false;
  bool _isLoadingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authDataSource = ProfileLocalDataSourceImpl();
    final loggedIn = await authDataSource.checkAuthStatus();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _isLoadingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format creation time
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr =
        'Today, ${widget.ticket.createdTime.hour}:${widget.ticket.createdTime.minute.toString().padLeft(2, '0')} ${widget.ticket.createdTime.hour >= 12 ? 'PM' : 'AM'}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.6),
        elevation: 0,
        scrolledUnderElevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF6100D6)),
          onPressed: () {},
        ),
        title: const Text(
          'LuxeMall',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6100D6),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF4A4456),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Blueprint lines background simulation
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(painter: _BlueprintGridPainter()),
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header Text
                const Text(
                  'Issue Submitted',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28.0, // headline-lg-mobile
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30), // on-surface
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Your maintenance request has been successfully created.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0, // body-md
                    color: Color(0xFF4A4456), // on-surface-variant
                  ),
                ),
                const SizedBox(height: 24.0),
                // Ticket Success Card
                _buildSuccessHeroCard(dateStr),
                const SizedBox(height: 24.0),
                // Live status arrival estimation card
                _buildLiveStatusCard(),
                const SizedBox(height: 24.0),
                // Request Details Card
                _buildDetailsCard(),
                const SizedBox(height: 24.0),
                // Service Roadmap Vertical Timeline
                TicketTimeline(
                  status: widget.ticket.status,
                  assignedTech:
                      widget.ticket.assignedTeam == 'Janitorial Team B'
                      ? 'Marcus Aurelius'
                      : 'Julius Caesar',
                ),
                const SizedBox(height: 32.0),
                // Guest Benefits login banner
                if (!_isLoadingAuth && !_isLoggedIn) _buildGuestBanner(context),
                const SizedBox(height: 32.0),
                // Grid actions buttons
                _buildActionButtons(context),
                const SizedBox(height: 64.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeroCard(String dateStr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6100D6),
            Color(0xFF0058BE),
          ], // primary to secondary
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Ticket Created Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Ticket ID: ${widget.ticket.ticketId}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0, // title-md
              fontWeight: FontWeight.w500,
              color: Color(
                0xFFD2BBFF,
              ), // primary-fixed-dim / text-primary-fixed
            ),
          ),
          const SizedBox(height: 24.0),
          const Divider(color: Colors.white24, height: 1.0, thickness: 1.0),
          const SizedBox(height: 24.0),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSuccessStatCol('Submitted Time', dateStr),
              _buildSuccessStatCol('Category', widget.ticket.category),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSuccessStatCol(
                'Status',
                widget.ticket.status,
                isBadge: true,
              ),
              _buildSuccessStatCol(
                'Estimated Fix',
                widget.ticket.estimatedFixTime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStatCol(
    String label,
    String val, {
    bool isBadge = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.0, // label-sm
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4.0),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(9999.0),
            ),
            child: Text(
              val,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.0, // label-lg
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        else
          Text(
            val,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.0, // title-md
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildLiveStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF), // bg-surface-container-low
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(0xFF6100D6),
              borderRadius: BorderRadius.circular(16.0),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.electric_bolt_outlined,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT UPDATE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.0, // label-sm
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4456), // on-surface-variant
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Estimated Tech Arrival: 15 Minutes',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0, // title-md
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30), // on-surface
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Queue Position: #3',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: Color(0xFF6100D6), // primary
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Request Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0, // title-lg
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6), // error-container
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  '${widget.ticket.priority} Priority'.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBA1A1A), // error
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(color: Color(0xFFEFF4FF), height: 1.0, thickness: 1.0),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _buildDetailsCol('Category', widget.ticket.category),
              ),
              Expanded(
                child: _buildDetailsCol('Location', widget.ticket.location),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildDetailsCol('Description', widget.ticket.description),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0,
                        color: Color(0xFF4A4456),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.image,
                          color: Color(0xFF6100D6),
                          size: 16.0,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          widget.ticket.photoUrl != null
                              ? '1 Photo Attached'
                              : '0 Photos Attached',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildDetailsCol(
                  'Department',
                  widget.ticket.assignedTeam,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCol(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.0, // label-sm
            color: Color(0xFF4A4456), // on-surface-variant
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          val,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0, // body-md
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B1C30), // on-surface
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: const Color(
          0xFFE5EEFF,
        ), // secondary-container / surface-container
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Your Reports',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.0, // headline-lg-mobile
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Sign in to get real-time push notifications, view your complete report history, and message technicians directly.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // body-lg
              color: Color(0xFF4A4456),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please navigate to the Profile tab to sign in.',
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1C30), // on-secondary-container
                borderRadius: BorderRadius.circular(9999.0),
              ),
              child: const Text(
                'Login / Sign Up',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                Icons.visibility_outlined,
                'View Ticket',
                const Color(0xFF6100D6),
                Colors.white,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyReportsPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildActionBtn(
                Icons.share_outlined,
                'Share Ticket',
                const Color(0xFF4A4456),
                const Color(0xFFEFF4FF),
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality simulated.'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                Icons.add_circle_outline,
                'Report Another',
                const Color(0xFF4A4456),
                const Color(0xFFEFF4FF),
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportIssuePage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildActionBtn(
                Icons.home_outlined,
                'Return Home',
                Colors.white,
                const Color(0xFF0058BE),
                () {
                  Navigator.maybePop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    IconData icon,
    String label,
    Color textColor,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.0,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: bgColor == Colors.white
                ? const Color(0xFF0058BE)
                : Colors.transparent,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0058BE).withOpacity(0.03)
      ..strokeWidth = 1.0;

    double gridSpacing = 24.0;

    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

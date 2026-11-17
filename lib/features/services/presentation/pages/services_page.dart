import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const services = [
    (
      'Reconnection',
      'Restore a disconnected service',
      Icons.sync_rounded,
    ),
    (
      'Relocation',
      'Move your connection to a new address',
      Icons.location_on_outlined,
    ),
    (
      'Transfer Ownership',
      'Change the owner of this connection',
      Icons.swap_horiz_rounded,
    ),
    (
      'Package Migration',
      'Upgrade or change your package',
      Icons.trending_up_rounded,
    ),
    (
      'Service Vacation',
      'Pause your service temporarily',
      Icons.wb_sunny_outlined,
    ),
    (
      'Termination',
      'Disconnect this service',
      Icons.power_settings_new_rounded,
    ),
    (
      'Refund Request',
      'Claim deposits or overpayments',
      Icons.attach_money_rounded,
    ),
    (
      'General Request',
      'Any other request or enquiry',
      Icons.description_outlined,
    ),
  ];

  /// Routes that open as their own full screen
  static const Map<String, String> _pushRoutes = {
    'Reconnection': AppRoutes.reconnection,
    'Relocation': AppRoutes.relocation,
    'Service Vacation': AppRoutes.serviceVacation,
    'Transfer Ownership': AppRoutes.transferOwnership,
    'Package Migration': AppRoutes.packageUpgrade,
  };

  void _onServiceTap(BuildContext context, String serviceName) {
    final route = _pushRoutes[serviceName];
    if (route != null && GoRouter.maybeOf(context) != null) {
      context.push(route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$serviceName selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // ── Top Header with Back Button and Brand Decoration ──
          _buildHeader(context),

          // ── Scrollable Body with Banner & 2-Column Grid ──
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 700 ? 4 : 2;

                return CustomScrollView(
                  slivers: [
                    // Banner Card
                    SliverToBoxAdapter(
                      child: _buildBanner(),
                    ),

                    // Grid of 8 Service Options
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 154,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final service = services[index];
                            return _buildServiceCard(context, service);
                          },
                          childCount: services.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF005DAA),
      child: ClipRect(
        child: Stack(
          children: [
            // Decorative circle ring in top right
            Positioned(
              right: 15,
              top: -35,
              child: Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                    width: 11,
                  ),
                ),
              ),
            ),

            // Decorative diagonal stripes in top right
            Positioned(
              right: 0,
              top: 24,
              child: Transform.rotate(
                angle: -0.75,
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 32,
              top: 38,
              child: Transform.rotate(
                angle: -0.75,
                child: Container(
                  width: 34,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            // Header Content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 16, 14),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () {
                        if (GoRouter.maybeOf(context)?.canPop() ?? false) {
                          context.pop();
                        } else if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Account Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF004D99), Color(0xFF0064C8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004D99).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative diagonal stripes on right
            Positioned(
              right: 22,
              top: -10,
              child: Transform.rotate(
                angle: -0.65,
                child: Container(
                  width: 72,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B0FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -6,
              bottom: 4,
              child: Transform.rotate(
                angle: -0.65,
                child: Container(
                  width: 62,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF42B244),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // Banner Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 44,
                    height: 38,
                    child: CustomPaint(
                      painter: _RouterWifiPainter(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    width: 1.5,
                    height: 38,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  const Expanded(
                    child: Text(
                      'Manage your connection and account services in one place.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    (String, String, IconData) service,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onServiceTap(context, service.$1),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFDCE6F2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFDEF0FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service.$3,
                color: const Color(0xFF005DAA),
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: Color(0xFF0A2540),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF005DAA),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                service.$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A6E85),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the router with Wi-Fi signal & antenna icon.
class _RouterWifiPainter extends CustomPainter {
  const _RouterWifiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 1. Modem box at bottom
    final boxRect = Rect.fromLTWH(0, size.height - 11, 38, 11);
    final rrect = RRect.fromRectAndRadius(boxRect, const Radius.circular(3));
    canvas.drawRRect(rrect, stroke);

    // 3 indicator dots inside modem box
    final dotY = boxRect.center.dy;
    canvas.drawCircle(Offset(boxRect.left + 7, dotY), 1.2, fill);
    canvas.drawCircle(Offset(boxRect.left + 12.5, dotY), 1.2, fill);
    canvas.drawCircle(Offset(boxRect.left + 18, dotY), 1.2, fill);

    // 2. Antenna on the right standing vertically
    final antennaX = boxRect.right - 5;
    canvas.drawLine(
      Offset(antennaX, boxRect.top),
      Offset(antennaX, 4),
      stroke,
    );

    // 3. Wi-Fi wave arcs to the left of the antenna
    final arcCenter = Offset(16, boxRect.top + 2);

    // Outer arc
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: 16),
      -2.45,
      1.7,
      false,
      stroke,
    );

    // Middle arc
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: 10),
      -2.45,
      1.7,
      false,
      stroke,
    );

    // Center small arc
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: 4.5),
      -2.45,
      1.7,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

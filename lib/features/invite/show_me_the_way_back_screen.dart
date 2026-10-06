import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'finish_path_screen.dart';

class InviteOutsidePathScreen extends StatelessWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const InviteOutsidePathScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.colors.cardBackground,

      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.lightGreyBlue),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New invite',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gandhi Bazaar · stop 13',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: _OutsidePathMapPainter(context.colors)),
          ),

          // Info Section
          Expanded(
            child: Container(
              color: context.colors.pageBackground,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card

                  // Warning Banner
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.redWarningLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: context.colors.redWarning,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You are outside the path area',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.redWarning,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Invites can only be taken inside your assigned area. Walk 180 m north-west to get back in.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: context.colors.redWarning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Report Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      border: Border.all(color: context.colors.disabledBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Is this shop in the wrong place on the map?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDarkBlue,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Tell your Ward Leader. They can widen the area or add this stop.',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.colors.secondaryText,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.lightGreyBlue,
                            foregroundColor: context.colors.primaryDarkBlue,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Report a map problem',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom action
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(
                top: BorderSide(color: context.colors.lightGreyBlue),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FinishPathScreen(
                      routeName: routeData?['routeName'] ?? 'Unknown Route',
                      traveledDistanceMeters: traveledDistanceMeters,
                      totalDistanceMeters: totalDistanceMeters,
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondaryText,
                  foregroundColor: context.colors.cardBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.navigation_outlined, size: 20),
                label: Text(
                  'Show me the way back',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutsidePathMapPainter extends CustomPainter {
  final AppColors colors;
  _OutsidePathMapPainter(this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background fill
    paint.color = colors.mapBackground;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Grid lines (white thick, grey thin)
    paint.style = PaintingStyle.stroke;

    // White lines
    paint.color = colors.cardBackground;
    paint.strokeWidth = 7;
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width, size.height * 0.75),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.35, size.height),
      paint,
    );

    // Geofence polygon (dashed)
    final pathPaint = Paint()
      ..color = colors.secondaryText.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final polygonPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.13)
      ..lineTo(size.width * 0.73, size.height * 0.11)
      ..lineTo(size.width * 0.75, size.height * 0.75)
      ..lineTo(size.width * 0.1, size.height * 0.78)
      ..close();
    canvas.drawPath(polygonPath, pathPaint);

    // Geofence border dashed (simulated)
    final borderPaint = Paint()
      ..color = colors.secondaryText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(polygonPath, borderPaint);

    // Trail Line
    final trailPaint = Paint()
      ..color = colors.primaryDarkBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

    final trailPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..lineTo(size.width * 0.35, size.height * 0.6)
      ..lineTo(size.width * 0.37, size.height * 0.33)
      ..lineTo(size.width * 0.58, size.height * 0.3);
    canvas.drawPath(trailPath, trailPaint);

    // Distance line (dashed red)
    final distLinePaint = Paint()
      ..color = colors.redWarningDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.76),
      Offset(size.width * 0.86, size.height * 0.86),
      distLinePaint,
    );

    // Distance Text
    final textSpan = TextSpan(
      text: '180 m',
      style: TextStyle(
        color: colors.redWarning,
        fontSize: 10,
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.77, size.height * 0.88));

    // Outside dot (Red)
    final redDotCenter = Offset(size.width * 0.88, size.height * 0.88);
    final redHaloPaint = Paint()
      ..color = colors.redWarningDark.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(redDotCenter, 22, redHaloPaint);

    final redDotPaint = Paint()
      ..color = colors.redWarningDark
      ..style = PaintingStyle.fill;
    canvas.drawCircle(redDotCenter, 6.5, redDotPaint);

    final redDotBorder = Paint()
      ..color = colors.cardBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(redDotCenter, 6.5, redDotBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

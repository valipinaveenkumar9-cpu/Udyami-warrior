import 'package:flutter/material.dart';

class MyPerformanceScreen extends StatefulWidget {
  const MyPerformanceScreen({super.key});

  @override
  State<MyPerformanceScreen> createState() => _MyPerformanceScreenState();
}

class _MyPerformanceScreenState extends State<MyPerformanceScreen> {
  String _selectedFilter = 'This Month';

  final List<String> _filterOptions = [
    'This Week',
    'This Month',
    'Last 3 Months',
  ];

  // Mock performance data based on selected filter
  Map<String, dynamic> get _performanceData {
    switch (_selectedFilter) {
      case 'This Week':
        return {
          'invites': '85',
          'downloads': '24',
          'points': '310',
          'dates': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          'invitePoints': [10.0, 15.0, 8.0, 20.0, 12.0, 18.0, 2.0],
          'downloadPoints': [3.0, 5.0, 2.0, 6.0, 3.0, 4.0, 1.0],
          'recent': [
            {'title': 'Invite Sent to Priya Nair', 'time': 'Today, 04:20 PM', 'type': 'invite'},
            {'title': 'App Downloaded by K. Selvam', 'time': 'Today, 02:15 PM', 'type': 'download'},
            {'title': 'Invite Sent to M. Rajesh', 'time': 'Yesterday, 06:10 PM', 'type': 'invite'},
          ]
        };
      case 'Last 3 Months':
        return {
          'invites': '940',
          'downloads': '280',
          'points': '3,650',
          'dates': ['Nov', 'Dec', 'Jan'],
          'invitePoints': [280.0, 310.0, 350.0],
          'downloadPoints': [80.0, 95.0, 105.0],
          'recent': [
            {'title': 'App Downloaded by Suresh G', 'time': '29 Sep, 03:30 PM', 'type': 'download'},
            {'title': 'Invite Sent to Kavitha M', 'time': '28 Sep, 11:45 AM', 'type': 'invite'},
            {'title': 'App Downloaded by Ramesh Kumar', 'time': '25 Sep, 05:10 PM', 'type': 'download'},
          ]
        };
      case 'This Month':
      default:
        return {
          'invites': '320',
          'downloads': '96',
          'points': '1,250',
          'dates': ['1 Jan', '8 Jan', '15 Jan', '22 Jan', '31 Jan'],
          'invitePoints': [22.0, 32.0, 40.0, 44.0, 42.0],
          'downloadPoints': [8.0, 14.0, 19.0, 26.0, 23.0],
          'recent': [
            {'title': 'Invite Sent to Suresh Kumar', 'time': 'Today, 02:30 PM', 'type': 'invite'},
            {'title': 'App Downloaded by Anand Raj', 'time': 'Yesterday, 11:15 AM', 'type': 'download'},
            {'title': 'Invite Sent to Kavitha M', 'time': '28 Sep, 04:45 PM', 'type': 'invite'},
            {'title': 'App Downloaded by Deepak S', 'time': '27 Sep, 09:20 AM', 'type': 'download'},
          ]
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _performanceData;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F52BA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Performance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Dropdown
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0F52BA)),
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFilter = newValue;
                        });
                      }
                    },
                    items: _filterOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Card 1: Invitations Distributed
            _buildStatCard(
              icon: Icons.near_me_rounded,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF16A34A),
              value: data['invites'] as String,
              label: 'Invitations Distributed',
            ),

            const SizedBox(height: 12),

            // Card 2: App Downloads
            _buildStatCard(
              icon: Icons.file_download_outlined,
              iconBgColor: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF2563EB),
              value: data['downloads'] as String,
              label: 'App Downloads',
            ),

            const SizedBox(height: 12),

            // Card 3: Total Points Earned
            _buildStatCard(
              icon: Icons.star_rounded,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xD9D97706),
              value: data['points'] as String,
              label: 'Total Points Earned',
            ),

            const SizedBox(height: 24),

            // Activity Trend Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
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
                        'Activity Trend',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _buildLegendDot(const Color(0xFF16A34A), 'Invites'),
                          const SizedBox(width: 12),
                          _buildLegendDot(const Color(0xFF2563EB), 'Downloads'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Line Graph Custom Painter
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: TrendLineChartPainter(
                        dates: List<String>.from(data['dates'] as List),
                        invitePoints: List<double>.from(data['invitePoints'] as List),
                        downloadPoints: List<double>.from(data['downloadPoints'] as List),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF0F52BA),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Recent Activity List
            ...List<Widget>.from(
              (data['recent'] as List).map((item) {
                final map = item as Map<String, dynamic>;
                final isInvite = map['type'] == 'invite';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isInvite ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                        child: Icon(
                          isInvite ? Icons.send_rounded : Icons.file_download_outlined,
                          size: 18,
                          color: isInvite ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              map['title'] as String,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              map['time'] as String,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isInvite ? const Color(0xFFF1F5F9) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isInvite ? '+1 Invite' : '+10 Pts',
                          style: TextStyle(
                            color: isInvite ? const Color(0xFF475569) : const Color(0xFFD97706),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Barlow Condensed',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// CustomPainter for smooth Trend Line Graph
class TrendLineChartPainter extends CustomPainter {
  final List<String> dates;
  final List<double> invitePoints;
  final List<double> downloadPoints;

  TrendLineChartPainter({
    required this.dates,
    required this.invitePoints,
    required this.downloadPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double paddingBottom = 24.0;
    final double graphHeight = size.height - paddingBottom;
    final double graphWidth = size.width;

    final Paint gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw horizontal grid lines
    for (int i = 0; i <= 3; i++) {
      final y = graphHeight * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(graphWidth, y), gridPaint);
    }

    // Determine max Y scale
    double maxVal = 60.0;
    for (var val in invitePoints) {
      if (val > maxVal) maxVal = val;
    }

    final double stepX = dates.length > 1 ? graphWidth / (dates.length - 1) : graphWidth;

    // Draw X-Axis Labels
    for (int i = 0; i < dates.length; i++) {
      final x = stepX * i;
      textPainter.text = TextSpan(
        text: dates[i],
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - (textPainter.width / 2), size.height - 14),
      );
    }

    // Draw Invites Curve (Green)
    _drawLineAndDots(
      canvas,
      points: invitePoints,
      maxVal: maxVal,
      graphHeight: graphHeight,
      stepX: stepX,
      lineColor: const Color(0xFF16A34A),
    );

    // Draw Downloads Curve (Blue)
    _drawLineAndDots(
      canvas,
      points: downloadPoints,
      maxVal: maxVal,
      graphHeight: graphHeight,
      stepX: stepX,
      lineColor: const Color(0xFF2563EB),
    );
  }

  void _drawLineAndDots(
    Canvas canvas, {
    required List<double> points,
    required double maxVal,
    required double graphHeight,
    required double stepX,
    required Color lineColor,
  }) {
    if (points.isEmpty) return;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final Paint dotOuterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = stepX * i;
      final y = graphHeight - (points[i] / maxVal * graphHeight * 0.85);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = stepX * (i - 1);
        final prevY = graphHeight - (points[i - 1] / maxVal * graphHeight * 0.85);
        final controlX1 = prevX + (x - prevX) / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + (x - prevX) / 2;
        final controlY2 = y;
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    // Draw node dots
    for (int i = 0; i < points.length; i++) {
      final x = stepX * i;
      final y = graphHeight - (points[i] / maxVal * graphHeight * 0.85);
      canvas.drawCircle(Offset(x, y), 5.0, dotOuterPaint);
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TrendLineChartPainter oldDelegate) => true;
}

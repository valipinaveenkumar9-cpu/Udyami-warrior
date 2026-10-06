import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import '../../core/utils/session_manager.dart';
import 'active_path_screen.dart';

class PathDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;

  const PathDetailsScreen({super.key, required this.routeData});

  @override
  State<PathDetailsScreen> createState() => _PathDetailsScreenState();
}

class _PathDetailsScreenState extends State<PathDetailsScreen> {
  late Map<String, dynamic> _routeData;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _routeData = widget.routeData;
  }

  Future<void> _fetchRouteDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String channelPartnerId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';
      if (channelPartnerId.isNotEmpty) {
        final response = await _apiService.getAssignedRoute(channelPartnerId);
        if (response != null && response['success'] == true) {
          List<dynamic> routes = response['data'] ?? [];
          for (var route in routes) {
            if (route['routeId'] == _routeData['routeId']) {
              setState(() {
                _routeData = route;
              });
              break;
            }
          }
        }
      }
    } catch (e) {
      print("Error refreshing route details: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeName = _routeData['routeName'] ?? 'Unknown Route';
    final distance = _routeData['plannedDistance']?.toString() ?? '0';
    final duration = _routeData['estimatedDuration']?.toString() ?? '0';
    final createdAt = _routeData['createdAt'] ?? 'N/A';
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          // Map area
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Stack(
              children: [
                // Map placeholder drawing
                CustomPaint(
                  size: Size(double.infinity, 190),
                  painter: _MapPainter(),
                ),
                // Zoom controls
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: context.colors.defaultText.withValues(alpha: 0.1), blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildZoomButton('+'),
                        Container(height: 1, width: 30, color: context.colors.lightGreyBlue),
                        _buildZoomButton('−'),
                      ],
                    ),
                  ),
                ),
                // Badge
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: context.colors.defaultText.withValues(alpha: 0.1), blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      'You are 340 m from the start',
                      style: TextStyle(fontSize: 12, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRouteDetails,
              child: ListView(
                padding: EdgeInsets.all(12),
              children: [
                // Info Card
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.lightGreyBlue),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Route', routeName),
                      _buildInfoRow('Distance', '${distance}m'),
                      _buildInfoRow('Duration', '$duration hrs'),
                      _buildInfoRow('Created', createdAt, isHighlight: true),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                // Banner Note
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.primaryDarkBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.description_outlined, color: context.colors.cardBackground, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note from Ravi Kumar',
                              style: TextStyle(
                                color: context.colors.cardBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Shops open after 10:30. Start from the north gate.',
                              style: TextStyle(
                                color: Color(0xFF9FB2CE),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            ),
            child: Builder(
              builder: (context) {
                final statusLower = (_routeData['status'] ?? 'assigned').toString().toLowerCase();
                final isStarted = statusLower == 'started' || statusLower == 'in progress';
                final isCompleted = statusLower == 'completed';

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivePathScreen(routeData: _routeData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStarted ? const Color(0xFFE0BB87) : 
                                       isCompleted ? context.colors.greenSuccess : 
                                       context.colors.primaryDarkBlue,
                      foregroundColor: isStarted ? const Color(0xFF5A3A10) : context.colors.cardBackground,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: Icon(isStarted ? Icons.near_me_outlined : isCompleted ? Icons.check_circle : Icons.assignment_turned_in, size: 20),
                    label: Text(
                      isStarted ? 'Continue working' : isCompleted ? 'View Route' : 'Accept & Start', 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(String label) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 18, color: AppColors.light.primaryDarkBlue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light.chartAxis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Color(0xFFD97706) : AppColors.light.primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = AppColors.light.mapBackground;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final gridPaint = Paint()
      ..color = Color(0xFFD3DDEA)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final whiteLinePaint = Paint()
      ..color = AppColors.light.cardBackground
      ..strokeWidth = 7;
    canvas.drawLine(Offset(0, 60), Offset(size.width, 60), whiteLinePaint);
    canvas.drawLine(Offset(0, 132), Offset(size.width, 132), whiteLinePaint);
    canvas.drawLine(Offset(96, 0), Offset(96, 190), whiteLinePaint);
    canvas.drawLine(Offset(232, 0), Offset(232, 190), whiteLinePaint);

    final polyPaint = Paint()
      ..color = AppColors.light.secondaryText.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    final polyPath = Path()
      ..moveTo(40, 30)
      ..lineTo(300, 24)
      ..lineTo(312, 168)
      ..lineTo(28, 172)
      ..close();
    canvas.drawPath(polyPath, polyPaint);

    final polyStrokePaint = Paint()
      ..color = AppColors.light.secondaryText
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    canvas.drawPath(polyPath, polyStrokePaint);

    final routePaint = Paint()
      ..color = AppColors.light.primaryDarkBlue
      ..strokeWidth = 3.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final routePath = Path()
      ..moveTo(70, 150)
      ..lineTo(96, 96)
      ..lineTo(150, 92)
      ..lineTo(166, 52)
      ..lineTo(232, 48)
      ..lineTo(268, 108);
    canvas.drawPath(routePath, routePaint);

    final dotPaint = Paint()..color = AppColors.light.primaryDarkBlue;
    canvas.drawCircle(Offset(96, 96), 4, dotPaint);
    canvas.drawCircle(Offset(150, 92), 4, dotPaint);
    canvas.drawCircle(Offset(166, 52), 4, dotPaint);
    canvas.drawCircle(Offset(232, 48), 4, dotPaint);

    final startPaint = Paint()..color = AppColors.light.greenSuccess;
    final endPaint = Paint()..color = AppColors.light.redWarningDark;
    final whiteStrokePaint = Paint()
      ..color = AppColors.light.cardBackground
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(Offset(70, 150), 6.5, startPaint);
    canvas.drawCircle(Offset(70, 150), 6.5, whiteStrokePaint);

    canvas.drawCircle(Offset(268, 108), 6.5, endPaint);
    canvas.drawCircle(Offset(268, 108), 6.5, whiteStrokePaint);

    canvas.drawCircle(Offset(52, 176), 18, Paint()..color = AppColors.light.orangeWarning.withValues(alpha: 0.22));
    canvas.drawCircle(Offset(52, 176), 6, Paint()..color = AppColors.light.orangeWarning);
    canvas.drawCircle(Offset(52, 176), 6, whiteStrokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

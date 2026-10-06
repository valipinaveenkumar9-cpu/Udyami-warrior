import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import '../../core/utils/session_manager.dart';
import 'active_path_screen.dart';
import 'journey_reports_screen.dart';

class MyPathsScreen extends StatefulWidget {
  const MyPathsScreen({super.key});

  @override
  State<MyPathsScreen> createState() => _MyPathsScreenState();
}

class _MyPathsScreenState extends State<MyPathsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _routes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    try {
      final String channelPartnerId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';
      
      if (channelPartnerId.isEmpty) {
        throw Exception('User ID not found in session');
      }

      final response = await _apiService.getAssignedRoute(channelPartnerId);
      
      if (mounted) {
        setState(() {
          if (response != null && response['success'] == true) {
            _routes = response['data'] ?? [];
          } else {
            _errorMessage = response?['message'] ?? 'Failed to fetch routes';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(showBackArrow: false),
      endDrawer: const CustomMenuDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JourneyReportsScreen()),
          );
        },
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Reports'),
        backgroundColor: const Color(0xFF1E7A54),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Online Status Banner
          Container(
            color: context.colors.lightGreyBlue,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.cloud_done_outlined, size: 16, color: context.colors.greenSuccess),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All work synced',
                    style: TextStyle(fontSize: 13, color: context.colors.greenSuccess, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    'Online',
                    style: TextStyle(fontSize: 11, color: context.colors.greenSuccess, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      

          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                    : RefreshIndicator(
                        onRefresh: _fetchRoutes,
                        child: _routes.isEmpty 
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: const Center(child: Text("No routes assigned to you.")),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _routes.length,
                                itemBuilder: (context, index) {
                                  final route = _routes[index];
                                  return _buildRouteCard(route);
                                },
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    final routeName = route['routeName'] ?? 'Unknown Route';
    final distance = route['plannedDistance']?.toString() ?? '0';
    final duration = route['estimatedDuration']?.toString() ?? '0';
    final status = route['status'] ?? 'Assigned';
    final routeId = route['routeId'] ?? '';
    
    // Pick styling based on status
    final statusLower = status.toString().toLowerCase();
    final isStarted = statusLower == 'started' || statusLower == 'in progress';
    final isCompleted = statusLower == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStarted ? const Color(0xFFE8D4BE) : context.colors.lightGreyBlue, 
          width: isStarted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isStarted ? const Color(0xFF505560) : const Color(0xFFFFF4DE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isStarted ? context.colors.cardBackground : const Color(0xFF8A5A00),
                  ),
                ),
              ),
              Text(
                'ID: ${routeId.length > 8 ? routeId.substring(0,8) : routeId}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF93A7C6),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: '$routeName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B4858),
                fontFamily: 'Barlow',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Distance: ${distance}m · Est. Duration: $duration hours',
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7C93)),
          ),
          const SizedBox(height: 20),
                    SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivePathScreen(routeData: route),
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
                label: Text(isStarted ? 'Continue working' : isCompleted ? 'View Route' : 'View & Accept', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}

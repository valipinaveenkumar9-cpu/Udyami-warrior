import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import '../../core/utils/session_manager.dart';
import '../../core/thems/app_colors.dart';
import 'package:intl/intl.dart';

class JourneyReportsScreen extends StatefulWidget {
  const JourneyReportsScreen({super.key});

  @override
  State<JourneyReportsScreen> createState() => _JourneyReportsScreenState();
}

class _JourneyReportsScreenState extends State<JourneyReportsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _reports = [];
  final String _channelPartnerId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    if (_channelPartnerId.isEmpty) return;

    try {
      final response = await _apiService.getJourneyReports('channel_partner', _channelPartnerId);
      if (response != null && response['success'] == true) {
        setState(() {
          _reports = response['data'] ?? [];
        });
      }
    } catch (e) {
      print("Error fetching journey reports: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return 'N/A';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Journey Reports', style: TextStyle(color: Color(0xFF16233A), fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF16233A)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchReports,
              child: _reports.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: Text('No completed journeys found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        return _buildReportCard(report);
                      },
                    ),
            ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final routeName = report['routeName'] ?? 'Unknown Route';
    final status = report['status'] ?? 'UNKNOWN';
    final coverage = report['coveragePercentage']?.toString() ?? '0';
    final actualDistance = report['actualDistance']?.toString() ?? '0';
    final plannedDistance = report['plannedDistance']?.toString() ?? '0';
    final completedAt = _formatDate(report['completedAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.lightGreyBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    routeName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16233A)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FDF3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFB3F5D9)),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E7A54)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE4E9F2), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetric('Coverage', '$coverage%')),
                Expanded(child: _buildMetric('Distance', '${actualDistance}m / ${plannedDistance}m')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF3D4B60)),
                const SizedBox(width: 8),
                Text(
                  'Completed on $completedAt',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF3D4B60)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7A99))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF16233A))),
      ],
    );
  }
}

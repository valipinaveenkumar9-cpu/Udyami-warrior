import 'package:flutter/material.dart';
import '../../models/circlepac_survey_models.dart';
import '../../data/circlepac_mock_repository.dart';
import '../../theme/circlepac_colors.dart';
import '../widgets/voter_card.dart';
import '../forms/circlepac_survey_form.dart';

class VoterDatabaseScreen extends StatefulWidget {
  const VoterDatabaseScreen({super.key});

  @override
  State<VoterDatabaseScreen> createState() => _VoterDatabaseScreenState();
}

class _VoterDatabaseScreenState extends State<VoterDatabaseScreen> {
  final CirclepacMockRepository _repository = CirclepacMockRepository();
  final TextEditingController _searchController = TextEditingController();

  VoterCategory? _selectedCategory; // null = All
  String _selectedQualityFilter = 'All';

  @override
  void initState() {
    super.initState();
    _repository.changeNotifier.addListener(_onRepositoryChanged);
  }

  @override
  void dispose() {
    _repository.changeNotifier.removeListener(_onRepositoryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRepositoryChanged() {
    if (mounted) setState(() {});
  }

  void _openSurveyForm({VoterRecord? voterToEdit}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CirclepacSurveyForm(initialVoter: voterToEdit),
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.file_upload_outlined, color: CirclepacColors.primaryGreen),
            SizedBox(width: 8),
            Text('Import Voter Data (Bulk)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload CSV or Excel voter lists from Election Commission or field canvassing sheets:',
              style: TextStyle(fontSize: 13, color: CirclepacColors.textBody),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CirclepacColors.activeGreenBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CirclepacColors.activeGreenBorder, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: CirclepacColors.primaryGreen, size: 36),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to select voter_data.csv / .xlsx',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: CirclepacColors.primaryGreen),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supported format: Name, EPIC, Mobile, Ward, Category',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: CirclepacColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulated Bulk Import: 125 voter records imported successfully!'),
                  backgroundColor: CirclepacColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CirclepacColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Import Records', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _exportVoterData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exported voter list (CSV) generated and downloaded to device.'),
        backgroundColor: CirclepacColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _repository.getSummaryMetrics();
    final voters = _repository.getVoters(
      searchQuery: _searchController.text,
      categoryFilter: _selectedCategory,
      qualityFilter: _selectedQualityFilter,
    );

    return Scaffold(
      backgroundColor: CirclepacColors.pageBg,
      body: CustomScrollView(
        slivers: [
          // Metrics & Summary Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Operations Action Bar (Primary CTA + Import/Export)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openSurveyForm(),
                          icon: const Icon(Icons.add, color: Colors.white, size: 20),
                          label: const Text(
                            'Add Voter Details',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CirclepacColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _showImportDialog,
                        icon: const Icon(Icons.file_upload_outlined, size: 18, color: CirclepacColors.primaryGreen),
                        label: const Text('Import', style: TextStyle(color: CirclepacColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12.5)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: CirclepacColors.activeGreenBorder),
                          backgroundColor: CirclepacColors.activeGreenBg,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _exportVoterData,
                        icon: const Icon(Icons.file_download_outlined, size: 18, color: CirclepacColors.primaryDark),
                        label: const Text('Export', style: TextStyle(color: CirclepacColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12.5)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: CirclepacColors.borderCol),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Voter Summary Metrics Cards
                  _buildMetricsGrid(metrics),
                  const SizedBox(height: 14),

                  // Data Quality Indicator Row
                  _buildDataQualityCard(metrics),
                  const SizedBox(height: 16),

                  // Search and Category Filter Bar
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildCategoryFilterChips(metrics),
                  const SizedBox(height: 14),

                  // List Header with count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voter Records (${voters.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CirclepacColors.primaryDark,
                        ),
                      ),
                      if (_selectedCategory != null || _searchController.text.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = null;
                              _searchController.clear();
                              _selectedQualityFilter = 'All';
                            });
                          },
                          child: const Text('Clear Filters', style: TextStyle(fontSize: 12, color: CirclepacColors.primaryGreen)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Voter Records List
          if (voters.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No voters match your search or filter',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try changing your search term or tap "Add Voter Details" to record a new voter survey.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voter = voters[index];
                    return VoterCard(
                      voter: voter,
                      onTap: () => _openSurveyForm(voterToEdit: voter),
                      onEdit: () => _openSurveyForm(voterToEdit: voter),
                      onDelete: () {
                        _repository.deleteVoter(voter.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deleted voter record: ${voter.name}'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              textColor: Colors.white,
                              onPressed: () => _repository.addVoter(voter),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: voters.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(VoterSummaryMetrics metrics) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CirclepacColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bar_chart, color: CirclepacColors.primaryGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Voter Summary',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CirclepacColors.activeGreenBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Total: ${metrics.totalVoters}',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: CirclepacColors.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricPill(
                label: 'Supporters',
                count: metrics.supportersCount,
                color: CirclepacColors.supporterGreen,
                bgColor: CirclepacColors.supporterBg,
                borderColor: CirclepacColors.supporterBorder,
              ),
              const SizedBox(width: 6),
              _buildMetricPill(
                label: 'Opponents',
                count: metrics.opponentsCount,
                color: CirclepacColors.opponentRed,
                bgColor: CirclepacColors.opponentBg,
                borderColor: CirclepacColors.opponentBorder,
              ),
              const SizedBox(width: 6),
              _buildMetricPill(
                label: 'Volunteer',
                count: metrics.volunteerCount,
                color: CirclepacColors.volunteerBlue,
                bgColor: CirclepacColors.volunteerBg,
                borderColor: CirclepacColors.volunteerBorder,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetricPill(
                label: 'Undecided',
                count: metrics.undecidedCount,
                color: CirclepacColors.undecidedAmber,
                bgColor: CirclepacColors.undecidedBg,
                borderColor: CirclepacColors.undecidedBorder,
              ),
              const SizedBox(width: 6),
              _buildMetricPill(
                label: 'Booth Worker',
                count: metrics.boothWorkerCount,
                color: CirclepacColors.boothWorkerPurple,
                bgColor: CirclepacColors.boothWorkerBg,
                borderColor: CirclepacColors.boothWorkerBorder,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataQualityCard(VoterSummaryMetrics metrics) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CirclepacColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_disabled_outlined, size: 16, color: CirclepacColors.errorRed),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Missing Phone', style: TextStyle(fontSize: 10, color: CirclepacColors.textMuted)),
                  Text('${metrics.missingPhoneEmailCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark)),
                ],
              ),
            ],
          ),
          Container(width: 1, height: 26, color: CirclepacColors.borderLight),
          Row(
            children: [
              const Icon(Icons.label_off_outlined, size: 16, color: CirclepacColors.undecidedAmber),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Untagged', style: TextStyle(fontSize: 10, color: CirclepacColors.textMuted)),
                  Text('${metrics.untaggedCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark)),
                ],
              ),
            ],
          ),
          Container(width: 1, height: 26, color: CirclepacColors.borderLight),
          Row(
            children: [
              const Icon(Icons.pause_circle_outline, size: 16, color: CirclepacColors.textMuted),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inactive', style: TextStyle(fontSize: 10, color: CirclepacColors.textMuted)),
                  Text('${metrics.inactiveCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        hintText: 'Search by voter name, mobile, EPIC or ward...',
        hintStyle: const TextStyle(color: CirclepacColors.textLight, fontSize: 13),
        prefixIcon: const Icon(Icons.search, size: 20, color: CirclepacColors.primaryGreen),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18, color: CirclepacColors.textMuted),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CirclepacColors.borderCol),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CirclepacColors.borderCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CirclepacColors.primaryGreen, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterChips(VoterSummaryMetrics metrics) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: Text('All (${metrics.totalVoters})'),
            selected: _selectedCategory == null,
            selectedColor: CirclepacColors.primaryGreen,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: _selectedCategory == null ? Colors.white : CirclepacColors.primaryDark,
            ),
            side: BorderSide(
              color: _selectedCategory == null ? CirclepacColors.primaryGreen : CirclepacColors.borderCol,
            ),
            onSelected: (_) => setState(() => _selectedCategory = null),
          ),
          const SizedBox(width: 6),
          ...VoterCategory.values.map((cat) {
            final isSelected = _selectedCategory == cat;
            int count = 0;
            switch (cat) {
              case VoterCategory.supporters:
                count = metrics.supportersCount;
                break;
              case VoterCategory.opponents:
                count = metrics.opponentsCount;
                break;
              case VoterCategory.volunteer:
                count = metrics.volunteerCount;
                break;
              case VoterCategory.undecided:
                count = metrics.undecidedCount;
                break;
              case VoterCategory.boothWorker:
                count = metrics.boothWorkerCount;
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                label: Text('${cat.pluralLabel} ($count)'),
                selected: isSelected,
                selectedColor: cat.bgColor,
                backgroundColor: Colors.white,
                checkmarkColor: cat.color,
                labelStyle: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? cat.color : CirclepacColors.primaryDark,
                ),
                side: BorderSide(
                  color: isSelected ? cat.color : CirclepacColors.borderCol,
                  width: isSelected ? 1.6 : 1.0,
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? cat : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

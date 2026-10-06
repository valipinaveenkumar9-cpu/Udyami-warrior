import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'field_survey_screen.dart';

class InvitesScreen extends StatefulWidget {
  const InvitesScreen({super.key});

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  
  final List<Map<String, String>> _allLeads = [
    {'name': 'Ramesh Kumar', 'phone': '98765 43210', 'type': 'Retail & Shops', 'status': 'Pending'},
    {'name': 'Sunidhi Enterprises', 'phone': '98765 43211', 'type': 'Manufacturing', 'status': 'Verified'},
    {'name': 'Anita Stores', 'phone': '98765 43212', 'type': 'Retail & Shops', 'status': 'Pending'},
    {'name': 'Vijay Traders', 'phone': '98765 43213', 'type': 'Trading', 'status': 'Verified'},
    {'name': 'Suresh Hardware', 'phone': '98765 43214', 'type': 'Hardware', 'status': 'Pending'},
    {'name': 'Om Logistics', 'phone': '98765 43215', 'type': 'Transport', 'status': 'Verified'},
    {'name': 'Anil Kumar', 'phone': '98765 43216', 'type': 'Individual', 'status': 'Verified'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLeadDetails(BuildContext context, String name, String phone, String type, String status) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.onSurface),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: status == 'Verified' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: status == 'Verified' ? Colors.green : Colors.orange,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'Verified' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailRow(Icons.phone_outlined, 'Phone', phone, colors),
              SizedBox(height: 12),
              _buildDetailRow(Icons.business_outlined, 'Sector', type, colors),
              SizedBox(height: 12),
              _buildDetailRow(Icons.location_on_outlined, 'Location', 'HSR Layout Ward - 12', colors),
              SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today_outlined, 'Added On', '31 Jul 2026', colors),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, ColorScheme colors) {
    return Row(
      children: [
        Icon(icon, color: colors.onSurfaceVariant, size: 20),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
            SizedBox(height: 2),
            Text(value, style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.onSurface.withValues(alpha: 0.1)),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Search leads...',
                          hintStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.onSurface.withValues(alpha: 0.1)),
                    ),
                    child: Icon(Icons.filter_alt_outlined, color: colors.onSurface),
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: colors.primary,
              unselectedLabelColor: colors.onSurfaceVariant,
              indicatorColor: colors.primary,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: 'All (20)'),
                Tab(text: 'Pending (6)'),
                Tab(text: 'Verified (12)'),
              ],
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeadsList(isAll: true, colors: colors),
                  _buildLeadsList(statusFilter: 'Pending', colors: colors),
                  _buildLeadsList(statusFilter: 'Verified', colors: colors),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.defaultText.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const FieldSurveyScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.add),
                label: Text('Add invite', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadsList({bool isAll = false, String? statusFilter, required ColorScheme colors}) {
    final displayedLeads = _allLeads.where((l) {
      final matchesStatus = isAll || l['status'] == statusFilter;
      final matchesSearch = l['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 24),
      itemCount: displayedLeads.length,
      itemBuilder: (context, index) {
        final lead = displayedLeads[index];
        return _buildLeadCard(
          lead['name']!,
          lead['phone']!,
          lead['type']!,
          lead['status']!,
          () => _showLeadDetails(context, lead['name']!, lead['phone']!, lead['type']!, lead['status']!),
          colors,
        );
      },
    );
  }

  Widget _buildLeadCard(String name, String phone, String type, String status, VoidCallback onTap, ColorScheme colors) {
    final isVerified = status == 'Verified';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colors.defaultText.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.onSurface),
                ),
                SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  type,
                  style: TextStyle(color: colors.onSurfaceVariant.withValues(alpha: 0.7), fontSize: 13),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isVerified ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isVerified ? Colors.green : Colors.orange,
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isVerified ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final nameCtrl = TextEditingController(text: 'Lakshmi Devi');
  final phoneCtrl = TextEditingController(text: '+91 99001 27384');
  String gender = 'Woman';
  String runBusiness = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Offline Banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.lightGreyBlue,
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: context.colors.secondaryText),
                SizedBox(width: 8),
                Text('Offline — this will save on your phone', style: TextStyle(fontSize: 12, color: context.colors.secondaryText, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
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
                  // Steps
                  Row(
                    children: [
                      _buildStep(true),
                      SizedBox(width: 4),
                      _buildStep(false),
                      SizedBox(width: 4),
                      _buildStep(false),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1 of 3 · About the person',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
                  ),
                  SizedBox(height: 24),

                  // Full name
                  _buildLabel('Full name *'),
                  _buildTextField(nameCtrl, false),
                  SizedBox(height: 16),

                  // Mobile number
                  _buildLabel('Mobile number *'),
                  _buildTextField(phoneCtrl, true),
                  SizedBox(height: 4),
                  Text(
                    '✓ New number — not registered before',
                    style: TextStyle(fontSize: 12, color: context.colors.greenSuccess, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),

                  // Gender
                  _buildLabel('Gender *'),
                  Row(
                    children: [
                      _buildSegment('Woman', gender == 'Woman', () => setState(() => gender = 'Woman')),
                      SizedBox(width: 8),
                      _buildSegment('Man', gender == 'Man', () => setState(() => gender = 'Man')),
                      SizedBox(width: 8),
                      _buildSegment('Other', gender == 'Other', () => setState(() => gender = 'Other')),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Run business
                  _buildLabel('Do they run a business?'),
                  Row(
                    children: [
                      _buildSegment('Yes', runBusiness == 'Yes', () => setState(() => runBusiness = 'Yes')),
                      SizedBox(width: 8),
                      _buildSegment('No', runBusiness == 'No', () => setState(() => runBusiness = 'No')),
                      SizedBox(width: 8),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Business details add 25 points when verified.',
                    style: TextStyle(fontSize: 12, color: context.colors.secondaryText),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Bottom button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddLeadBusinessScreen(
                        leadName: nameCtrl.text.trim(),
                      ),
                    ),
                  );
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primaryDarkBlue,
                  foregroundColor: context.colors.cardBackground,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text('Next — business', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? context.colors.primaryDarkBlue : context.colors.barNotHome,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.colors.secondaryText),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isMono) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.lightGreyBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: context.colors.primaryDarkBlue,
          fontFamily: isMono ? 'monospace' : null,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSegment(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primaryDarkBlue : context.colors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? context.colors.primaryDarkBlue : context.colors.barNotHome),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? context.colors.cardBackground : context.colors.primaryDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class AddLeadBusinessScreen extends StatefulWidget {
  final String leadName;
  const AddLeadBusinessScreen({super.key, required this.leadName});

  @override
  State<AddLeadBusinessScreen> createState() => _AddLeadBusinessScreenState();
}

class _AddLeadBusinessScreenState extends State<AddLeadBusinessScreen> {
  final businessNameCtrl = TextEditingController(text: 'Sri Lakshmi Tailors');
  final sectorCtrl = TextEditingController(text: 'Textiles & Apparel');
  final subSectorCtrl = TextEditingController(text: 'Tailoring & stitching');
  final yearsCtrl = TextEditingController(text: '8');
  final peopleCtrl = TextEditingController(text: '2–5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Offline Banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.lightGreyBlue,
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: context.colors.secondaryText),
                SizedBox(width: 8),
                Text('Offline — this will save on your phone', style: TextStyle(fontSize: 12, color: context.colors.secondaryText, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
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
                          'Lakshmi Devi',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Steps
                  Row(
                    children: [
                      _buildStep(true),
                      SizedBox(width: 4),
                      _buildStep(true),
                      SizedBox(width: 4),
                      _buildStep(false),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '2 of 3 · The business',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
                  ),
                  SizedBox(height: 24),

                  _buildLabel('Business name'),
                  _buildTextField(businessNameCtrl),
                  SizedBox(height: 16),

                  _buildLabel('Sector'),
                  _buildTextField(sectorCtrl),
                  SizedBox(height: 16),

                  _buildLabel('Sub-sector'),
                  _buildTextField(subSectorCtrl),
                  SizedBox(height: 16),

                  _buildLabel('Tags'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTagChip('Blouse work'),
                      _buildTagChip('Alterations'),
                      _buildAddTagChip('+ Add'),
                    ],
                  ),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Years running'),
                            _buildTextField(yearsCtrl),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('People working'),
                            _buildTextField(peopleCtrl),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: context.colors.cardBackground,
                        border: Border.all(color: context.colors.lightGreyBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: context.colors.primaryDarkBlue),
                          SizedBox(width: 8),
                          Text(
                            'Photo of shop front',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.colors.primaryDarkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Optional. Ask before taking a photo.',
                    style: TextStyle(fontSize: 12, color: context.colors.secondaryText),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Bottom button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newLead = {
                    'name': widget.leadName,
                    'phone': '+91 99001 27384',
                    'type': sectorCtrl.text.trim(),
                    'status': 'Pending'
                  };
                  Navigator.pop(context, newLead); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primaryDarkBlue,
                  foregroundColor: context.colors.cardBackground,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text('Next — consent', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? context.colors.primaryDarkBlue : context.colors.barNotHome,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.colors.secondaryText),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.lightGreyBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: context.colors.primaryDarkBlue,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.lightGreyBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildAddTagChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.lightGreyBlue, style: BorderStyle.solid),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
      ),
    );
  }
}


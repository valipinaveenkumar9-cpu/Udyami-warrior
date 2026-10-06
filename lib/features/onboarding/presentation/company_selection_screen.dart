import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import '../../auth/presentation/login_screen.dart';
import '../data/cloud_patra_api.dart';
import '../data/expo_ambassador_api.dart';
import 'forms/expo_ambassador_form.dart';
import 'forms/cloud_patra_form.dart';
import 'forms/ownify_form.dart';
import 'forms/bhoomi_vault_form.dart';
import 'forms/first_go_stay_form.dart';
import 'forms/first_choice_bank_form.dart';
import 'forms/build_ai_homes_form.dart';
import 'forms/yuva_udyami_form.dart';
import 'forms/default_company_form.dart';
import '../../circlepac/presentation/screens/circlepac_main_shell.dart';

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({super.key});

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  // Theme Palette
  static const Color ink = Color(0xFF1E2A44);
  static const Color paper = Color(0xFFF3EEDD);
  static const Color seal = Color(0xFF0E5C4A);
  static const Color gold = Color(0xFFA9791F);
  static const Color line = Color(0xFFD9D0B8);
  static const Color muted = Color(0xFF7A7360);
  static const Color saffron = Color(0xFFE67722);

  static const Map<String, dynamic> _expoCompany = {
    'id': 'expo',
    'name': 'EXPO Ambassador',
    'verticalName': 'EXPO Ambassador',
    'tagline': 'Be the face of the UB WARRIORS Expo',
    'description': 'Share the UB WARRIORS Expo invitation with your network and help people download our app.',
    'initials': 'EX',
    'color': Color(0xFFA9791F),
    'isFeatured': true,
  };

  static const List<Map<String, dynamic>> _allowedCompanies = [
    {
      'id': 'cloudpatra',
      'verticalName': 'Cloud Patra',
      'verticalId': 'cloud_patra_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'CP',
      'color': Color(0xFF0E5C4A),
    },
    {
      'id': 'bhoomivault',
      'verticalName': 'Bhoomi Vault',
      'verticalId': 'bhoomi_vault_vertical',
      'tagline': 'Partner program',
      'description': 'Liaisoning & Procurement Channel Partner',
      'initials': 'BV',
      'color': Color(0xFF6B4F1D),
    },
    {
      'id': 'ownify',
      'verticalName': 'Ownify',
      'verticalId': 'ownify_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'OW',
      'color': Color(0xFF1E2A44),
    },
    {
      'id': 'udyamiqueens',
      'verticalName': 'Udyami Queens',
      'verticalId': 'udyami_queens_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'UQ',
      'color': Color(0xFFA13D2E),
    },
    {
      'id': 'buildaihomes',
      'verticalName': 'Build AI Homes',
      'verticalId': 'build_ai_homes_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'BA',
      'color': Color(0xFF12735E),
    },
    {
      'id': 'buildmall',
      'verticalName': 'Build Mall Logistics',
      'verticalId': 'build_mall_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'BM',
      'color': Color(0xFF3E4A63),
    },
    {
      'id': 'firstchoice',
      'verticalName': 'First Choice Bank',
      'verticalId': 'first_choice_bank_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'FC',
      'color': Color(0xFF7A3E6E),
    },
    {
      'id': 'ubpac',
      'verticalName': 'UB PAC',
      'verticalId': 'circlepac_vertical',
      'tagline': 'Partner program',
      'description': 'Campaign & Voter Survey Management',
      'initials': 'UP',
      'color': Color(0xFF0A4438),
    },
    {
      'id': 'yuvaudyami',
      'verticalName': 'Yuva Udyami',
      'verticalId': 'yuva_udyami_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'YU',
      'color': Color(0xFFC2601C),
    },
    {
      'id': 'fcstay',
      'verticalName': 'First Choice Stay',
      'verticalId': 'first_go_stay_vertical',
      'tagline': 'Partner program',
      'description': 'Channel Partner Registration',
      'initials': 'FS',
      'color': Color(0xFF2F5D8A),
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _companies = List.from(_allowedCompanies);
  bool _isLoading = true;
  String _searchQuery = '';
  String? _expoAppliedId;

  @override
  void initState() {
    super.initState();
    _checkExistingApplication();
    _fetchCompanies();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  Future<void> _checkExistingApplication() async {
    try {
      final uid = SessionManager.userId;
      final mobile = SessionManager.user?['mobileNumber'] ?? SessionManager.user?['mobile'] ?? SessionManager.user?['phone'] ?? '';
      
      final savedId = (uid != null ? SessionManager.getString('last_submitted_expo_app_id_$uid') : null) ??
          (mobile.isNotEmpty ? SessionManager.getString('last_submitted_expo_app_id_$mobile') : null);
      
      if (savedId != null && savedId.isNotEmpty) {
        if (mounted) {
          setState(() {
            _expoAppliedId = savedId;
          });
        }
      }

      final res = await ExpoAmbassadorApi.getMyApplications();
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        final expoApp = res.data!.firstWhere(
          (app) => (app['programType'] ?? '').toString().toUpperCase() == 'EXPO_AMBASSADOR',
          orElse: () => null,
        );
        if (expoApp != null) {
          final appId = (expoApp['applicationNumber'] ?? expoApp['applicationId'] ?? expoApp['_id'] ?? expoApp['id']).toString();
          if (mounted) {
            setState(() {
              _expoAppliedId = appId;
            });
          }
          if (uid != null) {
            await SessionManager.setString('last_submitted_expo_app_id_$uid', appId);
          }
          if (mobile.isNotEmpty) {
            await SessionManager.setString('last_submitted_expo_app_id_$mobile', appId);
          }
        } else {
          if (mounted) {
            setState(() {
              _expoAppliedId = null;
            });
          }
          if (uid != null) await SessionManager.remove('last_submitted_expo_app_id_$uid');
          if (mobile.isNotEmpty) await SessionManager.remove('last_submitted_expo_app_id_$mobile');
        }
      } else {
        if (mounted) {
          setState(() {
            _expoAppliedId = null;
          });
        }
        if (uid != null) await SessionManager.remove('last_submitted_expo_app_id_$uid');
        if (mobile.isNotEmpty) await SessionManager.remove('last_submitted_expo_app_id_$mobile');
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCompanies() async {
    try {
      final data = await CloudPatraApi.getBusinessVerticals();
      if (data.isNotEmpty) {
        // Merge or populate API verticals if needed
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _companies = List.from(_allowedCompanies);
        _isLoading = false;
      });
    }
  }

  void _navigateToForm(String companyName, String verticalId) {
    Widget targetScreen;
    final lowerName = companyName.toLowerCase().trim();
    final lowerId = verticalId.toLowerCase().trim();

    // 1. CloudPatra check
    if (lowerName.contains('cloud') || lowerName.contains('patra') || lowerName.contains('pathra') || lowerId.contains('cloud')) {
      targetScreen = CloudPatraForm(verticalId: verticalId, companyName: companyName);
    } 
    // 2. Ownify check
    else if (lowerName.contains('ownify') || lowerId.contains('ownify')) {
      targetScreen = OwnifyForm(companyName: companyName);
    } 
    // 3. CirclePac check
    else if (lowerName.contains('circlepac') || lowerName.contains('circle pac') || lowerName.contains('ub pac') || lowerId.contains('circlepac')) {
      targetScreen = CirclepacMainShell(companyName: companyName);
    } 
    // 4. BhoomiVault check
    else if (lowerName.contains('bhoomi') || lowerName.contains('vault') || lowerId.contains('bhoomi')) {
      targetScreen = BhoomiVaultForm(companyName: companyName, verticalId: verticalId);
    } 
    // 5. FIRST GO STAY check
    else if ((lowerName.contains('first go') || lowerName.contains('firstgo') || lowerName.contains('stay') || lowerId.contains('first_go_stay') || lowerId.contains('firstgo')) && !lowerName.contains('choice') && !lowerName.contains('bank')) {
      targetScreen = FirstGoStayForm(companyName: companyName, verticalId: verticalId);
    } 
    // 6. FIRST CHOICE BANK check
    else if ((lowerName.contains('first choice') || lowerName.contains('firstchoice') || lowerName.contains('bank') || lowerId.contains('firstchoice') || lowerId.contains('first_choice')) && !lowerName.contains('stay') && !lowerName.contains('go')) {
      targetScreen = FirstChoiceBankForm(companyName: companyName, verticalId: verticalId);
    } 
    // 7. Build AI Homes check
    else if (lowerName.contains('build ai') || lowerName.contains('build_ai') || lowerName.contains('build aihomes') || lowerId.contains('build_ai') || lowerId.contains('buildai')) {
      targetScreen = BuildAiHomesForm(companyName: companyName, verticalId: verticalId);
    } 
    // 8. Yuva Udyami check
    else if (lowerName.contains('yuva') || lowerName.contains('udyami') || lowerId.contains('yuva') || lowerId.contains('udyami')) {
      targetScreen = YuvaUdyamiForm(companyName: companyName, verticalId: verticalId);
    } 
    // Fallback
    else {
      targetScreen = DefaultCompanyForm(verticalId: verticalId, companyName: companyName);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  bool get _isExistingCp {
    return _expoAppliedId != null;
  }

  void _handleExpoTap() {
    if (_expoAppliedId != null) {
      _openExpoForm();
    } else if (_isExistingCp) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Already Approved CP'),
          content: const Text('Your number or email is already registered as an approved Channel Partner. Please log in to your account.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go to Login', style: TextStyle(fontWeight: FontWeight.bold, color: seal)),
            ),
          ],
        ),
      );
    } else {
      _openExpoForm();
    }
  }

  void _openExpoForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpoAmbassadorForm(
          onSubmitted: (appId) {
            setState(() {
              _expoAppliedId = appId;
            });
          },
        ),
      ),
    );
  }

  void _logout() async {
    await SessionManager.clearSession();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildTricolorBar() {
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Container(color: saffron)),
          Expanded(child: Container(color: paper)),
          Expanded(child: Container(color: seal)),
        ],
      ),
    );
  }

  Widget _buildExpoCard() {
    final matches = _searchQuery.isEmpty ||
        _expoCompany['name'].toLowerCase().contains(_searchQuery) ||
        _expoCompany['tagline'].toLowerCase().contains(_searchQuery);

    if (!matches) return const SizedBox.shrink();

    final applied = _expoAppliedId != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: _handleExpoTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: gold, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'EX',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: applied ? seal : gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        applied ? '✓ Applied' : '★ Special program',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _expoCompany['name'],
                      style: const TextStyle(
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF5B4415),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      applied ? 'Application ID: $_expoAppliedId' : _expoCompany['tagline'],
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B5624),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (applied)
                ElevatedButton(
                  onPressed: _openExpoForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: seal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View Status',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(dynamic c) {
    final name = (c['verticalName'] ?? c['name'] ?? '').toString();
    final tagline = (c['tagline'] ?? c['description'] ?? 'Partner program').toString();
    final initials = (c['initials'] ?? 'CP').toString();
    final color = (c['color'] as Color?) ?? seal;
    final verticalId = (c['verticalId'] ?? c['id'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => _navigateToForm(name, verticalId),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tagline,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCompanies = _companies.where((c) {
      if (_searchQuery.isEmpty) return true;
      final name = (c['verticalName'] ?? c['name'] ?? '').toString().toLowerCase();
      final tagline = (c['tagline'] ?? c['description'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || tagline.contains(_searchQuery);
    }).toList();

    final showExpo = _searchQuery.isEmpty ||
        _expoCompany['name'].toLowerCase().contains(_searchQuery) ||
        _expoCompany['tagline'].toLowerCase().contains(_searchQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ink, size: 18),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Choose a Company',
              style: TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: ink,
              ),
            ),
            Text(
              'Select where you want to register',
              style: TextStyle(fontSize: 11.5, color: muted),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: ink, size: 20),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _buildTricolorBar(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: line, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search, color: muted, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14.5, color: ink),
                          decoration: const InputDecoration(
                            hintText: 'Search companies',
                            hintStyle: TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: muted, size: 18),
                          onPressed: () => _searchController.clear(),
                        ),
                    ],
                  ),
                ),
              ),

              // Companies List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: seal))
                    : (!showExpo && filteredCompanies.isEmpty)
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'No companies match "${_searchController.text.trim()}".',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: muted, fontSize: 13),
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            children: [
                              _buildExpoCard(),
                              if (showExpo && filteredCompanies.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 2),
                                  child: Text(
                                    'Companies',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: muted,
                                    ),
                                  ),
                                ),
                              ],
                              ...filteredCompanies.map(_buildCompanyCard),
                              const SizedBox(height: 16),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

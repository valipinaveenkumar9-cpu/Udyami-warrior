import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UbExpoBrochureScreen extends StatefulWidget {
  const UbExpoBrochureScreen({super.key});

  @override
  State<UbExpoBrochureScreen> createState() => _UbExpoBrochureScreenState();
}

class _UbExpoBrochureScreenState extends State<UbExpoBrochureScreen> {
  late PdfViewerController _pdfViewerController;
  int _totalPages = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1726),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'UB EXPO 2026 Brochure',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_totalPages > 0)
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(
                  color: Color(0xFFF1E7CC),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Client Explanation Info',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1E2A44),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '🎪 UB EXPO 2026 Key Highlights',
                        style: TextStyle(
                          color: Color(0xFFF1E7CC),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Dates: Dec 4–6, 2026\n'
                        '• Venue: BIEC Bengaluru\n'
                        '• Footfall: 50,000+ Visitors Expected\n'
                        '• Exhibitors: 500+ Businesses\n'
                        '• Sectors: 16 Focus Industry Sectors\n\n'
                        'Tip for Channel Partners: Tap left side of screen for previous page, right side for next page, or swipe horizontally to flip pages!',
                        style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.asset(
            'assets/docs/ub_expo_2026.pdf',
            controller: _pdfViewerController,
            pageLayoutMode: PdfPageLayoutMode.single,
            scrollDirection: PdfScrollDirection.horizontal,
            enableDoubleTapZooming: true,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _totalPages = details.document.pages.count;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                _currentPage = details.newPageNumber;
              });
            },
          ),

          // Left Touch Overlay Zone for Turning to Previous Page
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _previousPage,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: _currentPage > 1
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          // Right Touch Overlay Zone for Turning to Next Page
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _nextPage,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: _currentPage < _totalPages
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF0E1726),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _currentPage > 1 ? _previousPage : null,
              ),
              Expanded(
                child: Text(
                  'Page $_currentPage of $_totalPages  (Tap left/right or swipe)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: _currentPage < _totalPages ? _nextPage : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

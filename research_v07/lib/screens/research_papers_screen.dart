import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:logging/logging.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Add this import
import 'package:google_fonts/google_fonts.dart'; // Add this import
import '../services/pdf_service.dart';
import '../screens/pdf_viewer_screen.dart';

class ResearchPapersScreen extends StatefulWidget {
  final String professorName;

  const ResearchPapersScreen({
    super.key,
    required this.professorName,
  });

  @override
  State<ResearchPapersScreen> createState() => _ResearchPapersScreenState();
}

class _ResearchPapersScreenState extends State<ResearchPapersScreen> {
  final _pdfService = PdfService();
  final _logger = Logger('ResearchPapersScreen');
  List<File> _papers = [];
  List<Map<String, String>> _webPapers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final String _defaultSortBy = 'name';
  String _sortBy = 'name'; // 'name', 'date', 'views'
  String _filterYear = 'all';

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  Future<void> _loadPapers() async {
    setState(() => _isLoading = true);
    try {
      _logger.info('Loading papers for: ${widget.professorName}');
      if (kIsWeb) {
        _webPapers = _pdfService.getWebPapers(widget.professorName);
        _logger.info('Web papers found: ${_webPapers.length}');
      } else {
        _papers = await _pdfService.getProfessorPapers(widget.professorName);
        _logger.info('Native papers found: ${_papers.length}');
      }
      setState(() => _isLoading = false);
    } catch (e) {
      _logger.severe('Error loading papers: $e');
      setState(() {
        _papers = [];
        _webPapers = [];
        _isLoading = false;
      });
    }
  }

  List<dynamic> _getSortedPapers() {
    final papers = kIsWeb ? _webPapers : _papers;

    switch (_sortBy) {
      case 'name':
        if (kIsWeb) {
          return List.from(papers)
            ..sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        } else {
          return List.from(papers)
            ..sort((a, b) => path
                .basenameWithoutExtension(a.path)
                .compareTo(path.basenameWithoutExtension(b.path)));
        }
      case 'date':
        // Implement date sorting logic
        return papers;
      case 'views':
        // Implement views sorting logic
        return papers;
      default:
        return papers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: Column(
          children: [
            _buildFilterSection(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : kIsWeb
                      ? _buildWebPapersList()
                      : _buildNativePapersList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 110, // Reduced height
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
        color: Colors.black87,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Research Papers',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              widget.professorName,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 54, bottom: 16),
        centerTitle: false,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87),
          onPressed: () => _showSearchModal(context),
        ),
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.black87),
          onPressed: () => _showSortOptions(context),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Sort by',
            icon: Icons.sort,
            onPressed: () => _showSortOptions(context),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Year: $_filterYear',
            icon: Icons.calendar_today,
            onPressed: () => _showYearFilter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildWebPapersList() {
    if (_webPapers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _webPapers.length,
      itemBuilder: (context, index) {
        final paper = _webPapers[index];
        // Format the title by removing underscores and improving capitalization
        final title = paper['title'] as String? ?? '';
        final formattedTitle = title
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                : '')
            .join(' ');

        final path = paper['path'] as String? ?? '';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf, color: Colors.indigo),
            ),
            title: Text(
              formattedTitle,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Click to view PDF',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            onTap: () => _openWebPdf(path),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildNativePapersList() {
    if (_papers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _papers.length,
      itemBuilder: (context, index) {
        final paper = _papers[index];
        final title = path
            .basenameWithoutExtension(paper.path)
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                : '')
            .join(' ');

        return _buildPaperCard(
          title: title,
          year: DateTime.now().year.toString(),
          abstract: "Abstract not available",
          onTap: () => _openPdf(paper),
        );
      },
    );
  }

  Widget _buildPaperCard({
    required String title,
    required String year,
    required String abstract,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Published in $year',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Abstract',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        abstract,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No research papers found for ${widget.professorName}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _openPdf(File file) {
    final title = path.basenameWithoutExtension(file.path).replaceAll('_', ' ');
    // Extract author from path or set default
    final author =
        widget.professorName; // Use the professor's name as the author

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewScreen(
          pdfPath: file.path,
          title: title,
          author: author, // Add the author parameter
        ),
      ),
    );
  }

  void _openWebPdf(String path) {
    _logger.info('Opening web PDF: $path');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              path.split('/').last.replaceAll('_', ' ').replaceAll('.pdf', ''),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Stack(
            children: [
              SfPdfViewer.asset(
                'assets/$path', // Add 'assets/' prefix
                controller: PdfViewerController(),
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                onDocumentLoadFailed: (details) {
                  _logger.severe('Failed to load PDF: ${details.error}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to load PDF: ${details.error}')),
                  );
                },
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildSearchModal(),
    );
  }

  Widget _buildSearchModal() {
    // Implementation for search modal
    return Container(); // Add your search modal implementation
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterModal(),
    );
  }

  Widget _buildFilterModal() {
    // Implementation for filter modal
    return Container(); // Add your filter modal implementation
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Sort by Name'),
            leading: const Icon(Icons.sort_by_alpha),
            selected: _sortBy == 'name',
            onTap: () {
              setState(() => _sortBy = 'name');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Sort by Date'),
            leading: const Icon(Icons.calendar_today),
            selected: _sortBy == 'date',
            onTap: () {
              setState(() => _sortBy == 'date');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Sort by Views'),
            leading: const Icon(Icons.remove_red_eye),
            selected: _sortBy == 'views',
            onTap: () {
              setState(() => _sortBy == 'views');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showYearFilter(BuildContext context) {
    // Implementation for year filter
  }
}

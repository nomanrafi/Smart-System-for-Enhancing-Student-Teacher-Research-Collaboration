import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logging/logging.dart';
import '../services/pdf_service.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfPath;
  final String title;
  final String author;

  const PdfViewScreen({
    super.key,
    required this.pdfPath,
    required this.title,
    required this.author,
  });

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final _logger = Logger('PdfViewScreen');
  late PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  final _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _trackView();
  }

  Future<void> _trackView() async {
    await _pdfService.trackPaperView(
      widget.title,
      widget.author,
      widget.pdfPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (kIsWeb)
            SfPdfViewer.asset(
              widget.pdfPath,
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() => _isLoading = false);
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                _logger.severe('Failed to load PDF: ${details.error}');
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to load PDF: ${details.error}')),
                );
              },
            )
          else
            SfPdfViewer.file(
              File(widget.pdfPath),
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadPdf() async {
    try {
      setState(() => _isLoading = true);

      final response = await http.get(Uri.parse(widget.pdfPath));
      final bytes = response.bodyBytes;

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.title}.pdf');

      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF downloaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sharePdf() async {
    try {
      setState(() => _isLoading = true);

      final response = await http.get(Uri.parse(widget.pdfPath));
      final bytes = response.bodyBytes;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.title}.pdf');

      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: widget.title,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:logging/logging.dart';

class CustomPdfViewer extends StatefulWidget {
  final String pdfPath;
  final String title;

  const CustomPdfViewer({
    super.key,
    required this.pdfPath,
    required this.title,
  });

  @override
  State<CustomPdfViewer> createState() => _CustomPdfViewerState();
}

class _CustomPdfViewerState extends State<CustomPdfViewer> {
  final _logger = Logger('CustomPdfViewer');
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              _pdfViewerController.zoomLevel++;
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              _pdfViewerController.zoomLevel--;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Text(_errorMessage!),
            )
          else if (kIsWeb)
            SfPdfViewer.network(
              widget.pdfPath,
              controller: _pdfViewerController,
              onDocumentLoaded: (details) {
                setState(() => _isLoading = false);
              },
              onDocumentLoadFailed: (details) {
                _logger.severe('Failed to load PDF: ${details.error}');
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'Failed to load PDF: ${details.error}';
                });
              },
            )
          else
            SfPdfViewer.file(
              File(widget.pdfPath),
              controller: _pdfViewerController,
              onDocumentLoaded: (details) {
                setState(() => _isLoading = false);
              },
              onDocumentLoadFailed: (details) {
                _logger.severe('Failed to load PDF: ${details.error}');
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'Failed to load PDF: ${details.error}';
                });
              },
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/pdf_service.dart';
import 'pdf_viewer_screen.dart';

class CategoryPapersScreen extends StatelessWidget {
  final String category;
  final PdfService _pdfService = PdfService();

  CategoryPapersScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final papers = _pdfService.getPapersByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: papers.isEmpty
          ? Center(
              child: Text(
                'No papers found in this category',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: papers.length,
              itemBuilder: (context, index) {
                final paper = papers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.picture_as_pdf,
                          color: Colors.indigo),
                    ),
                    title: Text(
                      paper['title'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Author: ${paper['author']}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewScreen(
                            pdfPath: paper['path'] ?? '',
                            title: paper['title'] ?? '',
                            author: paper['author'] ?? '',
                          ),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
    );
  }
}

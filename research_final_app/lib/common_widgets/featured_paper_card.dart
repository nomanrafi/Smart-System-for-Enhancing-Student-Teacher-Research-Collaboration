import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/pdf_viewer_screen.dart';
import '../services/pdf_service.dart'; // Add this import

class FeaturedPaperCard extends StatelessWidget {
  final String title;
  final String author;
  final String views;
  final String downloads;
  final Color color;
  final VoidCallback? onTap;

  const FeaturedPaperCard({
    super.key,
    required this.title,
    required this.author,
    required this.views,
    required this.downloads,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 300,
          height: 200, // Add fixed height
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trending Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Trending',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Author and Stats
              Row(
                children: [
                  // Author Image
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          AssetImage('assets/images/faculty/noori_siRk.jpg'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Author Name and Stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          author,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStat(Icons.remove_red_eye, views),
                            const SizedBox(width: 16),
                            _buildStat(Icons.download, downloads),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Add this
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class Paper {
  final String title;
  final String author;
  final int viewCount;
  final int downloadCount;
  final String path;

  Paper({
    required this.title,
    required this.author,
    required this.viewCount,
    required this.downloadCount,
    required this.path,
  });
}

class PaperListScreen extends StatelessWidget {
  final List<Paper> papers;
  final PdfService _pdfService = PdfService();

  PaperListScreen({super.key, required this.papers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers'),
      ),
      body: ListView.builder(
        itemCount: papers.length,
        itemBuilder: (context, index) {
          final paper = papers[index];
          return FeaturedPaperCard(
            color: Colors.primaries[index % Colors.primaries.length],
            title: paper.title,
            author: paper.author,
            views: '${paper.viewCount}',
            downloads: '${paper.downloadCount}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewScreen(
                    pdfPath: paper.path,
                    title: paper.title,
                    author: paper.author,
                  ),
                ),
              );
              _pdfService.trackPaperView(
                paper.title,
                paper.author,
                paper.path,
              );
            },
          );
        },
      ),
    );
  }
}

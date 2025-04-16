// Add this import to any file using ResearchPaper

class ResearchPaper {
  final String id;
  final String title;
  final String author;
  final String journalName;
  final String year;
  final String pdfUrl;
  final String doi;
  final List<String> keywords;
  final String abstract; // Keep this required
  final int citations;

  ResearchPaper({
    required this.id,
    required this.title,
    required this.author,
    required this.journalName,
    required this.year,
    required this.pdfUrl,
    required this.doi,
    required this.keywords,
    required this.abstract, // This parameter is required
    this.citations = 0,
  });

  // Add factory method to create from JSON
  factory ResearchPaper.fromJson(Map<String, dynamic> json) {
    return ResearchPaper(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      journalName: json['journalName'] as String,
      year: json['year'] as String,
      pdfUrl: json['pdfUrl'] as String,
      doi: json['doi'] as String,
      keywords: List<String>.from(json['keywords'] ?? []),
      abstract: json['abstract'] as String, // Required field
      citations: json['citations'] as int? ?? 0,
    );
  }

  // Add method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'journalName': journalName,
      'year': year,
      'pdfUrl': pdfUrl,
      'doi': doi,
      'keywords': keywords,
      'abstract': abstract, // Include abstract in JSON
      'citations': citations,
    };
  }
}

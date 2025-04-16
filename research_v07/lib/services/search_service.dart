import '../models/research_paper.dart';
import '../models/faculty.dart';
import '../data/faculty_data.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  // Search papers
  List<ResearchPaper> searchPapers(String query) {
    if (query.isEmpty) return [];

    query = query.toLowerCase();
    List<ResearchPaper> results = [];

    // Search through all faculty research papers
    facultyResearchPapers.forEach((_, papers) {
      results.addAll(papers.where((paper) {
        return paper.title.toLowerCase().contains(query) ||
            paper.author.toLowerCase().contains(query) ||
            paper.abstract.toLowerCase().contains(query) ||
            paper.keywords
                .any((keyword) => keyword.toLowerCase().contains(query));
      }));
    });

    return results;
  }

  // Search faculty
  List<Faculty> searchFaculty(String query) {
    if (query.isEmpty) return [];

    query = query.toLowerCase();
    return facultyMembers.where((faculty) {
      return faculty.name.toLowerCase().contains(query) ||
          faculty.department.toLowerCase().contains(query) ||
          faculty.designation.toLowerCase().contains(query);
    }).toList();
  }

  // Combined search
  Map<String, dynamic> searchAll(String query) {
    return {
      'papers': searchPapers(query),
      'faculty': searchFaculty(query),
    };
  }
}

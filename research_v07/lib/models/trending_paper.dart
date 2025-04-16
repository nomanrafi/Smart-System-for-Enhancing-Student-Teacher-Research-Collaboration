class TrendingPaper {
  final String title;
  final String author;
  final String path;
  final int viewCount;
  final int downloadCount;
  final DateTime lastViewed;

  TrendingPaper({
    required this.title,
    required this.author,
    required this.path,
    required this.viewCount,
    required this.downloadCount,
    required this.lastViewed,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'path': path,
        'viewCount': viewCount,
        'downloadCount': downloadCount,
        'lastViewed': lastViewed.toIso8601String(),
      };

  factory TrendingPaper.fromJson(Map<String, dynamic> json) => TrendingPaper(
        title: json['title'],
        author: json['author'],
        path: json['path'],
        viewCount: json['viewCount'],
        downloadCount: json['downloadCount'],
        lastViewed: DateTime.parse(json['lastViewed']),
      );
}

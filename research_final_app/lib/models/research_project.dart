import 'package:hive/hive.dart';

part 'research_project.g.dart';

@HiveType(typeId: 0)
class ResearchProject extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final double progress;

  @HiveField(7)
  final List<String> teamMembers;

  @HiveField(8)
  final List<String> tags;

  @HiveField(9)
  final String fundingSource;

  @HiveField(10)
  final double budget;

  @HiveField(11)
  final List<String> publications;

  @HiveField(12)
  final List<String> documents;

  ResearchProject({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.teamMembers,
    required this.tags,
    this.fundingSource = '',
    this.budget = 0.0,
    this.publications = const [],
    this.documents = const [],
  });

  factory ResearchProject.fromJson(Map<String, dynamic> json) {
    return ResearchProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      progress: json['progress'] as double,
      teamMembers: List<String>.from(json['teamMembers']),
      tags: List<String>.from(json['tags']),
      fundingSource: json['fundingSource'] as String? ?? '',
      budget: json['budget'] as double? ?? 0.0,
      publications: List<String>.from(json['publications'] ?? []),
      documents: List<String>.from(json['documents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'progress': progress,
      'teamMembers': teamMembers,
      'tags': tags,
      'fundingSource': fundingSource,
      'budget': budget,
      'publications': publications,
      'documents': documents,
    };
  }
}

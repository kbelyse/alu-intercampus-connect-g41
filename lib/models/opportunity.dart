// Opportunity model for competitions, roles, grants, and programs.
class Opportunity {
  final String id;
  final String title;
  final String description;
  final String type;
  final String campus;
  final DateTime deadline;
  final String category;
  final List<String> tags;
  final String imageUrl;

  const Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.campus,
    required this.deadline,
    required this.category,
    this.tags = const [],
    required this.imageUrl,
  });
}

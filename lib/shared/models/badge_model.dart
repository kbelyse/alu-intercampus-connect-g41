class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final BadgeCategory category;
  final int pointsRequired;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.category,
    required this.pointsRequired,
  });
}

enum BadgeCategory { engagement, leadership, community, innovation, impact }

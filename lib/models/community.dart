// Community model for clubs and interest groups.
class Community {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final String category;
  final String lastActivity;
  final bool isActiveNow;
  final String colorHex;
  final String bannerImageUrl;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.category,
    required this.lastActivity,
    this.isActiveNow = false,
    required this.colorHex,
    required this.bannerImageUrl,
  });
}

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String coverUrl;
  final List<String> tags;
  final int memberCount;
  final bool isTrending;
  final String campus;
  final List<String> memberAvatars;
  final String lastActivity;
  final int weeklyPosts;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coverUrl,
    required this.tags,
    required this.memberCount,
    required this.isTrending,
    required this.campus,
    this.memberAvatars = const [],
    required this.lastActivity,
    required this.weeklyPosts,
  });

  CommunityModel copyWith({
    int? memberCount,
    bool? isTrending,
    List<String>? memberAvatars,
  }) {
    return CommunityModel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      coverUrl: coverUrl,
      tags: tags,
      memberCount: memberCount ?? this.memberCount,
      isTrending: isTrending ?? this.isTrending,
      campus: campus,
      memberAvatars: memberAvatars ?? this.memberAvatars,
      lastActivity: lastActivity,
      weeklyPosts: weeklyPosts,
    );
  }
}

class StartupModel {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String logoUrl;
  final List<String> tags;
  final String founderName;
  final String founderAvatar;
  final String founderId;
  final String stage;
  final List<String> openRoles;
  final bool isLookingForCofounder;
  final String campus;
  final int teamSize;
  final String website;

  const StartupModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.logoUrl,
    required this.tags,
    required this.founderName,
    required this.founderAvatar,
    required this.founderId,
    required this.stage,
    required this.openRoles,
    required this.isLookingForCofounder,
    required this.campus,
    required this.teamSize,
    this.website = '',
  });
}

class CollaborationRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String role;
  final String description;
  final List<String> skills;
  final DateTime postedAt;
  final bool isActive;

  const CollaborationRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.role,
    required this.description,
    required this.skills,
    required this.postedAt,
    required this.isActive,
  });
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String campus;
  final String major;
  final String bio;
  final List<String> interests;
  final int cohort;
  final int eventsAttended;
  final int communitiesJoined;
  final int rsvpCount;
  final int leadershipPoints;
  final int networkingScore;
  final int participationStreak;
  final List<String> earnedBadgeIds;
  final List<String> savedEventIds;
  final List<String> rsvpedEventIds;
  final List<String> joinedCommunityIds;
  final List<String> savedOpportunityIds;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.campus,
    required this.major,
    required this.bio,
    required this.interests,
    required this.cohort,
    this.eventsAttended = 0,
    this.communitiesJoined = 0,
    this.rsvpCount = 0,
    this.leadershipPoints = 0,
    this.networkingScore = 0,
    this.participationStreak = 0,
    this.earnedBadgeIds = const [],
    this.savedEventIds = const [],
    this.rsvpedEventIds = const [],
    this.joinedCommunityIds = const [],
    this.savedOpportunityIds = const [],
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? campus,
    String? major,
    String? bio,
    List<String>? interests,
    int? cohort,
    int? eventsAttended,
    int? communitiesJoined,
    int? rsvpCount,
    int? leadershipPoints,
    int? networkingScore,
    int? participationStreak,
    List<String>? earnedBadgeIds,
    List<String>? savedEventIds,
    List<String>? rsvpedEventIds,
    List<String>? joinedCommunityIds,
    List<String>? savedOpportunityIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      campus: campus ?? this.campus,
      major: major ?? this.major,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      cohort: cohort ?? this.cohort,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      communitiesJoined: communitiesJoined ?? this.communitiesJoined,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      leadershipPoints: leadershipPoints ?? this.leadershipPoints,
      networkingScore: networkingScore ?? this.networkingScore,
      participationStreak: participationStreak ?? this.participationStreak,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      savedEventIds: savedEventIds ?? this.savedEventIds,
      rsvpedEventIds: rsvpedEventIds ?? this.rsvpedEventIds,
      joinedCommunityIds: joinedCommunityIds ?? this.joinedCommunityIds,
      savedOpportunityIds: savedOpportunityIds ?? this.savedOpportunityIds,
    );
  }
}

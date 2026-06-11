// User model representing an ALU student profile.
class AppUser {
  final String id;
  final String name;
  final String initials;
  final String campus;
  final String email;
  final int eventsAttended;
  final int communities;
  final int connections;
  final List<String> badges;
  final String avatarUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.initials,
    required this.campus,
    required this.email,
    this.eventsAttended = 0,
    this.communities = 0,
    this.connections = 0,
    this.badges = const [],
    required this.avatarUrl,
  });
}

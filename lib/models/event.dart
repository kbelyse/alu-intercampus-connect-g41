// Event model representing a campus event or activity.
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String campus;
  final String category;
  final String organizer;
  final int attendeeCount;
  final int interestedCount;
  final int? maxParticipants;
  final List<String> tags;
  final String location;
  final String imageUrl;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.campus,
    required this.category,
    required this.organizer,
    this.attendeeCount = 0,
    this.interestedCount = 0,
    this.maxParticipants,
    this.tags = const [],
    this.location = '',
    required this.imageUrl,
  });
}

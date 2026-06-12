enum EventType { workshop, hackathon, networking, pitch, seminar, social, summit, competition }

class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final String organizer;
  final String organizerAvatarUrl;
  final List<String> categories;
  final int attendeeCount;
  final int maxAttendees;
  final bool isFeatured;
  final EventType type;
  final String campus;
  final List<String> participantAvatars;
  final double relevanceScore;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.organizer,
    required this.organizerAvatarUrl,
    required this.categories,
    required this.attendeeCount,
    required this.maxAttendees,
    required this.isFeatured,
    required this.type,
    required this.campus,
    this.participantAvatars = const [],
    this.relevanceScore = 0.0,
  });

  EventModel copyWith({double? relevanceScore}) {
    return EventModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      date: date,
      location: location,
      organizer: organizer,
      organizerAvatarUrl: organizerAvatarUrl,
      categories: categories,
      attendeeCount: attendeeCount,
      maxAttendees: maxAttendees,
      isFeatured: isFeatured,
      type: type,
      campus: campus,
      participantAvatars: participantAvatars,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }

  String get typeLabel {
    switch (type) {
      case EventType.workshop:
        return 'Workshop';
      case EventType.hackathon:
        return 'Hackathon';
      case EventType.networking:
        return 'Networking';
      case EventType.pitch:
        return 'Pitch Night';
      case EventType.seminar:
        return 'Seminar';
      case EventType.social:
        return 'Social';
      case EventType.summit:
        return 'Summit';
      case EventType.competition:
        return 'Competition';
    }
  }
}

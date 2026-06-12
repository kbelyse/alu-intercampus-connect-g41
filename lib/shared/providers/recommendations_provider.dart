import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import 'user_provider.dart';
import 'events_provider.dart';
import 'communities_provider.dart';

/// AI Recommendation Engine (frontend simulation)
///
/// Scores each event based on:
/// 1. Direct interest match with user's selected interests (+3.0)
/// 2. Category overlap with past RSVP'd events (+1.5)
/// 3. Tag overlap with joined communities (+1.0)
/// 4. Featured boost (+2.0)
/// 5. Popularity factor (attendeeCount/100)
///
/// The engine re-computes dynamically as user actions update state,
/// creating the illusion of a learning recommendation system.
final recommendedEventsProvider = Provider<List<EventModel>>((ref) {
  final user = ref.watch(userProvider);
  final allEvents = ref.watch(allEventsProvider);
  final joinedCommunities = ref.watch(joinedCommunitiesProvider);

  // Collect categories from RSVP'd events
  final rsvpedCategories = <String>{};
  for (final eventId in user.rsvpedEventIds) {
    final event = allEvents.cast<EventModel?>().firstWhere(
      (e) => e?.id == eventId,
      orElse: () => null,
    );
    if (event != null) {
      rsvpedCategories.addAll(event.categories);
    }
  }

  // Collect tags from joined communities
  final communityTags = <String>{};
  for (final community in joinedCommunities) {
    communityTags.addAll(community.tags);
  }

  // Score events
  final scoredEvents = allEvents.map((event) {
    double score = 0.0;

    // 1. Direct interest match
    for (final interest in user.interests) {
      if (event.categories.contains(interest)) {
        score += 3.0;
      }
    }

    // 2. Category overlap with past RSVPs
    for (final category in rsvpedCategories) {
      if (event.categories.contains(category)) {
        score += 1.5;
      }
    }

    // 3. Community tag overlap
    for (final tag in communityTags) {
      if (event.categories.contains(tag)) {
        score += 1.0;
      }
    }

    // 4. Featured boost
    if (event.isFeatured) score += 2.0;

    // 5. Popularity factor
    score += event.attendeeCount / 150.0;

    // 6. Slight recency bonus for upcoming events
    final daysUntil = event.date.difference(DateTime.now()).inDays;
    if (daysUntil >= 0 && daysUntil <= 14) score += 1.5;

    return event.copyWith(relevanceScore: score);
  }).toList();

  // Sort by score descending, filter out already RSVP'd
  scoredEvents.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

  return scoredEvents
      .where((e) => !user.rsvpedEventIds.contains(e.id))
      .take(6)
      .toList();
});

// Saved events provider
final savedEventsProvider = Provider<List<EventModel>>((ref) {
  final user = ref.watch(userProvider);
  final allEvents = ref.watch(allEventsProvider);
  return allEvents.where((e) => user.savedEventIds.contains(e.id)).toList();
});

// RSVP'd events provider
final rsvpedEventsProvider = Provider<List<EventModel>>((ref) {
  final user = ref.watch(userProvider);
  final allEvents = ref.watch(allEventsProvider);
  return allEvents.where((e) => user.rsvpedEventIds.contains(e.id)).toList();
});

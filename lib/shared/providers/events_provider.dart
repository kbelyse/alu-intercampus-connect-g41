import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../../mock/mock_events.dart';

final allEventsProvider = Provider<List<EventModel>>((ref) => MockEvents.events);

final featuredEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(allEventsProvider).where((e) => e.isFeatured).toList();
});

final upcomingEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(allEventsProvider)
    ..sort((a, b) => a.date.compareTo(b.date));
});

final eventByIdProvider = Provider.family<EventModel?, String>((ref, id) {
  try {
    return ref.watch(allEventsProvider).firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
});

// Search provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<EventModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return [];
  return ref.watch(allEventsProvider).where((e) {
    return e.title.toLowerCase().contains(query) ||
        e.description.toLowerCase().contains(query) ||
        e.categories.any((c) => c.toLowerCase().contains(query));
  }).toList();
});

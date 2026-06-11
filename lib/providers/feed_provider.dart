// Manages events, opportunities, active filter chip, campus filter, and search query.
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/opportunity.dart';
import '../models/community.dart';
import '../data/mock_data.dart';

enum FeedFilter { all, events, opportunities, clubs, academic }

class FeedProvider extends ChangeNotifier {
  FeedFilter _activeFilter = FeedFilter.all;
  String _searchQuery = '';
  String? _campusFilter; // null = All Campuses

  FeedFilter get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  String? get campusFilter => _campusFilter;

  List<Event> get events {
    var list = List<Event>.from(mockEvents);
    if (_campusFilter != null) {
      list = list
          .where((e) =>
              e.campus == _campusFilter ||
              e.campus == 'Both')
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.campus.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_activeFilter == FeedFilter.events) return list;
    if (_activeFilter == FeedFilter.academic) {
      return list.where((e) => e.category == 'Academic').toList();
    }
    return list;
  }

  List<Opportunity> get opportunities {
    var list = List<Opportunity>.from(mockOpportunities);
    if (_campusFilter != null) {
      list = list
          .where((o) => o.campus == _campusFilter || o.campus == 'Both')
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((o) =>
              o.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              o.campus.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_activeFilter == FeedFilter.opportunities) return list;
    return list;
  }

  /// Returns events matching the user's interests (joined communities + RSVPed categories),
  /// excluding events the user has already RSVPed to.
  List<Event> getRecommendations({
    required Set<String> rsvpedEventIds,
    required List<Community> joinedCommunities,
  }) {
    final rsvpCategories = mockEvents
        .where((e) => rsvpedEventIds.contains(e.id))
        .map((e) => e.category)
        .toSet();
    final communityCategories =
        joinedCommunities.map((c) => c.category).toSet();
    final interests = {...rsvpCategories, ...communityCategories};

    if (interests.isEmpty) return [];

    final now = DateTime.now();
    return mockEvents
        .where((e) =>
            !rsvpedEventIds.contains(e.id) &&
            interests.contains(e.category) &&
            e.startDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  void setFilter(FeedFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setCampus(String? campus) {
    _campusFilter = campus;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

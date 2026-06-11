// Manages events, opportunities, active filter chip, and search query.
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/opportunity.dart';
import '../data/mock_data.dart';

enum FeedFilter { all, events, opportunities, clubs, academic }

class FeedProvider extends ChangeNotifier {
  FeedFilter _activeFilter = FeedFilter.all;
  String _searchQuery = '';

  FeedFilter get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;

  List<Event> get events {
    var list = List<Event>.from(mockEvents);
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

  void setFilter(FeedFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

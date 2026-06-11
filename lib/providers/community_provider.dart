// Manages community list and which communities the user has joined.
import 'package:flutter/foundation.dart';
import '../models/community.dart';
import '../data/mock_data.dart';

class CommunityProvider extends ChangeNotifier {
  final List<Community> _communities = List.from(mockCommunities);
  final Set<String> _joinedIds = {'c2', 'c4'};
  String _searchQuery = '';

  List<Community> get allCommunities => _filter(_communities);
  List<Community> get joinedCommunities =>
      _filter(_communities.where((c) => _joinedIds.contains(c.id)).toList());

  bool isJoined(String id) => _joinedIds.contains(id);

  String get searchQuery => _searchQuery;

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleJoin(String id) {
    if (_joinedIds.contains(id)) {
      _joinedIds.remove(id);
    } else {
      _joinedIds.add(id);
    }
    notifyListeners();
  }

  Community? getById(String id) {
    try {
      return _communities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Community> _filter(List<Community> list) {
    if (_searchQuery.isEmpty) return list;
    return list
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
}

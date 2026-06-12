import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../mock/mock_users.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(MockUsers.currentUser);

  void updateInterests(List<String> interests) {
    state = state.copyWith(interests: interests);
  }

  void updateProfile({String? name, String? bio, String? campus, String? major}) {
    state = state.copyWith(
      name: name ?? state.name,
      bio: bio ?? state.bio,
      campus: campus ?? state.campus,
      major: major ?? state.major,
    );
  }

  void rsvpEvent(String eventId) {
    if (!state.rsvpedEventIds.contains(eventId)) {
      final updated = List<String>.from(state.rsvpedEventIds)..add(eventId);
      state = state.copyWith(
        rsvpedEventIds: updated,
        rsvpCount: state.rsvpCount + 1,
        leadershipPoints: state.leadershipPoints + 10,
        eventsAttended: state.eventsAttended + 1,
      );
    }
  }

  void unRsvpEvent(String eventId) {
    if (state.rsvpedEventIds.contains(eventId)) {
      final updated = List<String>.from(state.rsvpedEventIds)..remove(eventId);
      state = state.copyWith(
        rsvpedEventIds: updated,
        rsvpCount: state.rsvpCount - 1,
        eventsAttended: state.eventsAttended - 1,
      );
    }
  }

  void saveEvent(String eventId) {
    if (!state.savedEventIds.contains(eventId)) {
      final updated = List<String>.from(state.savedEventIds)..add(eventId);
      state = state.copyWith(savedEventIds: updated);
    }
  }

  void unsaveEvent(String eventId) {
    final updated = List<String>.from(state.savedEventIds)..remove(eventId);
    state = state.copyWith(savedEventIds: updated);
  }

  void joinCommunity(String communityId) {
    if (!state.joinedCommunityIds.contains(communityId)) {
      final updated = List<String>.from(state.joinedCommunityIds)..add(communityId);
      state = state.copyWith(
        joinedCommunityIds: updated,
        communitiesJoined: state.communitiesJoined + 1,
        networkingScore: state.networkingScore + 5,
        leadershipPoints: state.leadershipPoints + 15,
      );
      _checkBadges();
    }
  }

  void leaveCommunity(String communityId) {
    final updated = List<String>.from(state.joinedCommunityIds)..remove(communityId);
    state = state.copyWith(
      joinedCommunityIds: updated,
      communitiesJoined: state.communitiesJoined - 1,
    );
  }

  void saveOpportunity(String oppId) {
    if (!state.savedOpportunityIds.contains(oppId)) {
      final updated = List<String>.from(state.savedOpportunityIds)..add(oppId);
      state = state.copyWith(savedOpportunityIds: updated);
    }
  }

  void unsaveOpportunity(String oppId) {
    final updated = List<String>.from(state.savedOpportunityIds)..remove(oppId);
    state = state.copyWith(savedOpportunityIds: updated);
  }

  void _checkBadges() {
    final badges = List<String>.from(state.earnedBadgeIds);
    if (state.communitiesJoined >= 3 && !badges.contains('badge_002')) {
      badges.add('badge_002');
      state = state.copyWith(earnedBadgeIds: badges);
    }
    if (state.eventsAttended >= 10 && !badges.contains('badge_003')) {
      badges.add('badge_003');
      state = state.copyWith(earnedBadgeIds: badges);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(),
);

final isOnboardedProvider = StateProvider<bool>((ref) => false);
final isLoggedInProvider = StateProvider<bool>((ref) => false);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_model.dart';
import '../../mock/mock_communities.dart';
import 'user_provider.dart';

class CommunitiesNotifier extends StateNotifier<List<CommunityModel>> {
  final Ref _ref;

  CommunitiesNotifier(this._ref) : super(MockCommunities.communities);

  void joinCommunity(String communityId) {
    state = state.map((c) {
      if (c.id == communityId) {
        return c.copyWith(memberCount: c.memberCount + 1);
      }
      return c;
    }).toList();
    _ref.read(userProvider.notifier).joinCommunity(communityId);
  }

  void leaveCommunity(String communityId) {
    state = state.map((c) {
      if (c.id == communityId) {
        return c.copyWith(memberCount: c.memberCount - 1);
      }
      return c;
    }).toList();
    _ref.read(userProvider.notifier).leaveCommunity(communityId);
  }
}

final communitiesProvider = StateNotifierProvider<CommunitiesNotifier, List<CommunityModel>>(
  (ref) => CommunitiesNotifier(ref),
);

final trendingCommunitiesProvider = Provider<List<CommunityModel>>((ref) {
  return ref.watch(communitiesProvider).where((c) => c.isTrending).toList();
});

final communityByIdProvider = Provider.family<CommunityModel?, String>((ref, id) {
  try {
    return ref.watch(communitiesProvider).firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
});

final joinedCommunitiesProvider = Provider<List<CommunityModel>>((ref) {
  final user = ref.watch(userProvider);
  final communities = ref.watch(communitiesProvider);
  return communities.where((c) => user.joinedCommunityIds.contains(c.id)).toList();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/opportunity_model.dart';
import '../../mock/mock_opportunities.dart';
import 'user_provider.dart';

final allOpportunitiesProvider = Provider<List<OpportunityModel>>(
  (ref) => MockOpportunities.opportunities,
);

final savedOpportunitiesProvider = Provider<List<OpportunityModel>>((ref) {
  final user = ref.watch(userProvider);
  final all = ref.watch(allOpportunitiesProvider);
  return all.where((o) => user.savedOpportunityIds.contains(o.id)).toList();
});

final opportunityByIdProvider = Provider.family<OpportunityModel?, String>((ref, id) {
  try {
    return ref.watch(allOpportunitiesProvider).firstWhere((o) => o.id == id);
  } catch (_) {
    return null;
  }
});

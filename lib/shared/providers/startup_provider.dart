import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mock/mock_startups.dart';
import '../models/startup_model.dart';

final startupsProvider = Provider<List<StartupModel>>((ref) => MockStartups.startups);

final collaborationRequestsProvider = Provider<List<CollaborationRequestModel>>(
  (ref) => MockStartups.collaborationRequests,
);

final badgesProvider = Provider<List<BadgeModelSimple>>((ref) => MockStartups.badges);

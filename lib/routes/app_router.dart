import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/shell/main_shell.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/communities/screens/community_discovery_screen.dart';
import '../features/communities/screens/community_details_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/community_chat_screen.dart';
import '../features/profile/screens/user_profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/opportunities/screens/opportunity_details_screen.dart';
import '../features/opportunities/screens/saved_opportunities_screen.dart';
import '../features/opportunities/screens/my_events_screen.dart';
import '../features/opportunities/screens/search_results_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/startup/screens/startup_hub_screen.dart';
import '../features/dashboard/screens/growth_dashboard_screen.dart';
import '../features/create/screens/create_opportunity_screen.dart';
import '../features/communities/screens/my_communities_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fade(state, const SplashScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _slide(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slide(state, const LoginScreen()),
      ),

      // Push-only routes (no shell)
      GoRoute(
        path: '/opportunity/:id',
        pageBuilder: (context, state) => _slide(
          state,
          OpportunityDetailsScreen(eventId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/community/:id',
        pageBuilder: (context, state) => _slide(
          state,
          CommunityDetailsScreen(communityId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/chat/:id',
        pageBuilder: (context, state) => _slide(
          state,
          CommunityChatScreen(roomId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _slide(state, const NotificationsScreen()),
      ),
      GoRoute(
        path: '/saved',
        pageBuilder: (context, state) => _slide(state, const SavedOpportunitiesScreen()),
      ),
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => _slide(state, const StartupHubScreen()),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _slide(state, const GrowthDashboardScreen()),
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) => _slide(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _slide(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/my-events',
        pageBuilder: (context, state) => _slide(state, const MyEventsScreen()),
      ),
      GoRoute(
        path: '/my-communities',
        pageBuilder: (context, state) => _slide(state, const MyCommunitiesScreen()),
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) => _slide(state, const SearchResultsScreen()),
      ),

      // Main shell with bottom nav
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, shell) => NoTransitionPage(
          child: MainShell(navigationShell: shell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/communities',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CommunityDiscoveryScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CreateOpportunityScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChatListScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

CustomTransitionPage _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 320),
  );
}

// GoRouter config: ShellRoute for bottom-nav persistence, push routes for details.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/create/create_post_screen.dart';
import '../screens/events/event_detail_screen.dart';
import '../screens/communities/community_detail_screen.dart';
import '../screens/chats/chats_screen.dart';
import '../screens/chats/chat_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/my_rsvps_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../widgets/navigation/main_scaffold.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/splash',
      pageBuilder: (context, state) => _fade(state, const SplashScreen()),
    ),

    // Shell for persistent bottom nav
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _fade(state, const HomeScreen()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
              _fade(state, const ExploreScreen()),
        ),
        GoRoute(
          path: '/chats',
          pageBuilder: (context, state) =>
              _fade(state, const ChatsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _fade(state, const ProfileScreen()),
        ),
      ],
    ),

    // Full-screen routes (bypass shell)
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/create',
      pageBuilder: (context, state) =>
          _slideUp(state, const CreatePostScreen()),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/events/:id',
      pageBuilder: (context, state) => _slideUp(
        state,
        EventDetailScreen(
            eventId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/communities/:id',
      pageBuilder: (context, state) => _slideUp(
        state,
        CommunityDetailScreen(
            communityId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/chats/:id',
      pageBuilder: (context, state) => _slideUp(
        state,
        ChatDetailScreen(roomId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/profile/rsvps',
      pageBuilder: (context, state) =>
          _slideUp(state, const MyRsvpsScreen()),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: '/profile/notifications',
      pageBuilder: (context, state) =>
          _slideUp(state, const NotificationsScreen()),
    ),
  ],
);

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slideUp(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondary, child) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
    );

// Root app widget: wires up MultiProvider, AppTheme, and GoRouter.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/rsvp_provider.dart';
import 'providers/community_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/notification_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => RsvpProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp.router(
        title: 'ALU Intercampus Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}

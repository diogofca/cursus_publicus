import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'providers/auth_providers.dart';
import 'screens/author_console_screen.dart';
import 'screens/login_screen.dart';
import 'screens/recipient_feed_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppTheme.background,
        textTheme: GoogleFonts.googleSansTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      ),
      child: authState.when(
        data: (user) => _routeForUser(user),
        loading: () => const _SplashScreen(key: ValueKey('splash')),
        error: (_, _) => const LoginScreen(key: ValueKey('login')),
      ),
    );
  }

  Widget _routeForUser(User? user) {
    if (user == null) return const LoginScreen(key: ValueKey('login'));
    if (user.uid == kAuthorUid) {
      return const AuthorConsoleScreen(key: ValueKey('author'));
    }
    if (user.uid == kRecipientUid) {
      return const RecipientFeedScreen(key: ValueKey('recipient'));
    }
    return _UnknownAccountScreen(key: const ValueKey('unknown'), user: user);
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      ),
    );
  }
}

class _UnknownAccountScreen extends ConsumerWidget {
  const _UnknownAccountScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This account isn\'t set up for this app.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(authServiceProvider).signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

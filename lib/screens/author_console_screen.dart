import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/auth_providers.dart';
import '../providers/letters_providers.dart';
import '../theme.dart';
import '../widgets/letter_list_view.dart';
import 'compose_letter_screen.dart';
import 'letter_detail_screen.dart';

class AuthorConsoleScreen extends ConsumerWidget {
  const AuthorConsoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lettersAsync = ref.watch(allLettersProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ComposeLetterScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background_login.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kAppName,
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Write and manage your letters',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white70),
                        onPressed: () => ref.read(authServiceProvider).signOut(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: lettersAsync.when(
                    data: (letters) => LetterListView(
                      letters: letters,
                      showScheduledBadge: true,
                      emptyMessage: 'No letters yet — write your first one.',
                      onTapLetter: (letter) => Navigator.of(context).push(
                        LetterDetailScreen.route(letter),
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white70),
                    ),
                    error: (e, st) => const Center(
                      child: Text(
                        'Couldn\'t load letters.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

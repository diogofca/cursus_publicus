import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/auth_providers.dart';
import '../providers/letters_providers.dart';
import '../theme.dart';
import '../widgets/letter_list_view.dart';
import 'letter_detail_screen.dart';

class RecipientFeedScreen extends ConsumerWidget {
  const RecipientFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lettersAsync = ref.watch(visibleLettersProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                              'Letters for you, newest first',
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
                      emptyMessage: 'No letters yet — check back soon.',
                      onTapLetter: (letter) => Navigator.of(context).push(
                        LetterDetailScreen.route(letter),
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white70),
                    ),
                    error: (e, st) => Center(
                      child: Text(
                        'Couldn\'t load letters.',
                        style: const TextStyle(color: Colors.white70),
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

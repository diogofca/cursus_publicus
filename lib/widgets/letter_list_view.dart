import 'package:flutter/material.dart';

import '../models/letter.dart';
import 'letter_card.dart';

class LetterListView extends StatelessWidget {
  const LetterListView({
    super.key,
    required this.letters,
    required this.onTapLetter,
    this.showScheduledBadge = false,
    this.emptyMessage = 'No letters yet.',
  });

  final List<Letter> letters;
  final void Function(Letter letter) onTapLetter;
  final bool showScheduledBadge;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (letters.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        return LetterCard(
          letter: letter,
          index: index,
          showScheduledBadge: showScheduledBadge,
          onTap: () => onTapLetter(letter),
        );
      },
    );
  }
}

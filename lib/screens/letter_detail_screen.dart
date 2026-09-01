import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/letter.dart';
import '../services/spotify_service.dart';
import '../theme.dart';
import '../widgets/spotify_preview_card.dart';

class LetterDetailScreen extends StatelessWidget {
  const LetterDetailScreen({super.key, required this.letter});

  final Letter letter;

  /// An "unfolding letter" push transition: scale + fade, paired with the
  /// Hero the originating LetterCard already declares.
  static Route<void> route(Letter letter) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) =>
          LetterDetailScreen(letter: letter),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.94, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'letter-${letter.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  letter.title.isEmpty ? '(untitled letter)' : letter.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat.yMMMMd().add_jm().format(letter.visibleAt),
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Text(
              letter.body,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (letter.images.isNotEmpty) ...[
              const SizedBox(height: 24),
              ...letter.images.map(
                (data) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radiusforbuttons * 2),
                    child: Image.memory(base64Decode(data), fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
            if (letter.spotifyUrl != null && letter.spotifyUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SpotifySection(spotifyUrl: letter.spotifyUrl!),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpotifySection extends StatefulWidget {
  const _SpotifySection({required this.spotifyUrl});

  final String spotifyUrl;

  @override
  State<_SpotifySection> createState() => _SpotifySectionState();
}

class _SpotifySectionState extends State<_SpotifySection> {
  final _service = SpotifyService();
  SpotifyPreview? _preview;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preview = await _service.fetchOEmbed(widget.spotifyUrl);
    if (mounted) {
      setState(() {
        _preview = preview;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 56,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
        ),
      );
    }
    if (_preview == null) {
      return const Text(
        'Couldn\'t load the song preview.',
        style: TextStyle(color: Colors.white54, fontSize: 13),
      );
    }
    return SpotifyPreviewCard(preview: _preview!);
  }
}

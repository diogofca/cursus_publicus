import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../services/spotify_service.dart';

class SpotifyPreviewCard extends StatelessWidget {
  const SpotifyPreviewCard({super.key, required this.preview});

  final SpotifyPreview preview;

  Future<void> _open() async {
    final uri = Uri.parse(preview.spotifyUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusforbuttons * 2),
        onTap: _open,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withValues(alpha: 0.12),
            border: Border.all(color: const Color(0xFF1DB954), width: 1),
            borderRadius: BorderRadius.circular(radiusforbuttons * 2),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radiusforbuttons),
                child: preview.thumbnailUrl != null
                    ? Image.network(
                        preview.thumbnailUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _fallbackIcon(),
                      )
                    : _fallbackIcon(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Open in Spotify',
                      style: TextStyle(color: Color(0xFF1DB954), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, color: Color(0xFF1DB954), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackIcon() {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFF1DB954).withValues(alpha: 0.2),
      child: const Icon(Icons.music_note, color: Color(0xFF1DB954)),
    );
  }
}

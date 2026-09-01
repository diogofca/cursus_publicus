import 'dart:convert';

import 'package:http/http.dart' as http;

class SpotifyPreview {
  final String title;
  final String? thumbnailUrl;
  final String spotifyUrl;

  const SpotifyPreview({
    required this.title,
    required this.thumbnailUrl,
    required this.spotifyUrl,
  });
}

class SpotifyService {
  static bool isSpotifyUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return false;
    return uri.host == 'open.spotify.com' || uri.host == 'spotify.link';
  }

  /// Fetches title/artwork for a Spotify track/album/playlist link via
  /// Spotify's public oEmbed endpoint. No API key or auth required.
  /// Returns null if the URL isn't a Spotify link or the fetch fails.
  Future<SpotifyPreview?> fetchOEmbed(String spotifyUrl) async {
    final trimmed = spotifyUrl.trim();
    if (!isSpotifyUrl(trimmed)) return null;

    final endpoint = Uri.https('open.spotify.com', '/oembed', {
      'url': trimmed,
    });

    try {
      final response = await http.get(endpoint);
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return SpotifyPreview(
        title: data['title'] as String? ?? 'Spotify link',
        thumbnailUrl: data['thumbnail_url'] as String?,
        spotifyUrl: trimmed,
      );
    } catch (_) {
      return null;
    }
  }
}

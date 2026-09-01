import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/letter.dart';
import '../services/letters_repository.dart';
import '../services/spotify_service.dart';

final lettersRepositoryProvider = Provider<LettersRepository>((ref) {
  return LettersRepository(FirebaseFirestore.instance);
});

final spotifyServiceProvider = Provider<SpotifyService>((ref) {
  return SpotifyService();
});

final visibleLettersProvider = StreamProvider<List<Letter>>((ref) {
  return ref.watch(lettersRepositoryProvider).streamVisibleLetters();
});

final allLettersProvider = StreamProvider<List<Letter>>((ref) {
  return ref.watch(lettersRepositoryProvider).streamAllLetters();
});

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import '../models/letter.dart';

class LettersRepository {
  LettersRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(kLettersCollection);

  /// Letters visible to the recipient right now, newest first.
  Stream<List<Letter>> streamVisibleLetters() {
    return _collection
        .where('visibleAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('visibleAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Letter.fromFirestore).toList());
  }

  /// All of the author's letters (including future-scheduled ones), newest
  /// created first.
  Stream<List<Letter>> streamAllLetters() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Letter.fromFirestore).toList());
  }

  Future<void> createLetter(Letter letter) {
    return _collection.add(letter.toMap());
  }
}

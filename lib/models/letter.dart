import 'package:cloud_firestore/cloud_firestore.dart';

class Letter {
  final String id;
  final String authorUid;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime visibleAt;

  /// Photos, compressed and stored inline as base64 — this app runs on
  /// Firebase's free Spark plan, which has no Cloud Storage.
  final List<String> images;
  final String? spotifyUrl;

  const Letter({
    required this.id,
    required this.authorUid,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.visibleAt,
    required this.images,
    this.spotifyUrl,
  });

  bool get isVisibleNow => DateTime.now().isAfter(visibleAt);

  factory Letter.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Letter(
      id: doc.id,
      authorUid: data['authorUid'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      visibleAt: (data['visibleAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      images: List<String>.from(data['images'] as List? ?? const []),
      spotifyUrl: data['spotifyUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorUid': authorUid,
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
      'visibleAt': Timestamp.fromDate(visibleAt),
      'images': images,
      'spotifyUrl': spotifyUrl,
    };
  }
}

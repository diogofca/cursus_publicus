import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../models/letter.dart';
import '../providers/auth_providers.dart';
import '../providers/letters_providers.dart';
import '../services/spotify_service.dart';
import '../theme.dart';
import '../widgets/spotify_preview_card.dart';

class ComposeLetterScreen extends ConsumerStatefulWidget {
  const ComposeLetterScreen({super.key});

  @override
  ConsumerState<ComposeLetterScreen> createState() => _ComposeLetterScreenState();
}

class _PickedImage {
  final String name;
  final Uint8List bytes;
  const _PickedImage(this.name, this.bytes);
}

class _ComposeLetterScreenState extends ConsumerState<ComposeLetterScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _spotifyController = TextEditingController();

  final List<_PickedImage> _images = [];

  DateTime _visibleAt = DateTime.now();
  SpotifyPreview? _spotifyPreview;
  bool _checkingSpotify = false;
  bool _submitting = false;
  String? _error;

  int get _totalImageBytes => _images.fold(0, (sum, img) => sum + img.bytes.length);

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _spotifyController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= kMaxImagesPerLetter) {
      setState(() => _error = 'Up to $kMaxImagesPerLetter photos per letter (free Firestore plan).');
      return;
    }
    final picker = ImagePicker();
    // Compressed at pick time — letters run on Firebase's free Spark plan
    // (no Cloud Storage), so photos are embedded as base64 in the Firestore
    // document, which caps out at 1 MiB.
    final picked = await picker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    for (final xfile in picked) {
      if (_images.length >= kMaxImagesPerLetter) break;
      final bytes = await xfile.readAsBytes();
      if (_totalImageBytes + bytes.length > kMaxTotalImageBytes) {
        setState(() => _error = 'That photo would make this letter too big to save. Try fewer or smaller photos.');
        continue;
      }
      _images.add(_PickedImage(xfile.name, bytes));
    }
    if (mounted) setState(() {});
  }

  Future<void> _checkSpotifyLink() async {
    final url = _spotifyController.text.trim();
    if (url.isEmpty || !SpotifyService.isSpotifyUrl(url)) {
      setState(() => _spotifyPreview = null);
      return;
    }
    setState(() => _checkingSpotify = true);
    final preview = await ref.read(spotifyServiceProvider).fetchOEmbed(url);
    if (mounted) {
      setState(() {
        _spotifyPreview = preview;
        _checkingSpotify = false;
      });
    }
  }

  Future<void> _pickVisibleAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _visibleAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_visibleAt),
    );
    if (time == null) return;
    setState(() {
      _visibleAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty && _bodyController.text.trim().isEmpty) {
      setState(() => _error = 'Write something before sending.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final repo = ref.read(lettersRepositoryProvider);
      final authorUid = ref.read(authServiceProvider).currentUser?.uid ?? kAuthorUid;

      final letter = Letter(
        id: '',
        authorUid: authorUid,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        createdAt: DateTime.now(),
        visibleAt: _visibleAt,
        images: _images.map((img) => base64Encode(img.bytes)).toList(),
        spotifyUrl: _spotifyController.text.trim().isEmpty
            ? null
            : _spotifyController.text.trim(),
      );

      await repo.createLetter(letter);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _error = 'Couldn\'t send the letter. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('New Letter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: Colors.white24),
            TextField(
              controller: _bodyController,
              minLines: 6,
              maxLines: 20,
              style: const TextStyle(color: Colors.white, height: 1.5),
              decoration: const InputDecoration(
                hintText: 'Write your letter...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image_outlined, color: Colors.white70),
                  label: Text(
                    'Add photos (${_images.length}/$kMaxImagesPerLetter)',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _pickVisibleAt,
                  icon: const Icon(Icons.schedule, color: Colors.white70),
                  label: Text(
                    'Visible ${_formatVisibleAt(_visibleAt)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            if (_images.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(radiusforbuttons),
                          child: Image.memory(
                            image.bytes,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => _images.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black87,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _spotifyController,
              onChanged: (_) => _checkSpotifyLink(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Paste a Spotify link...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.music_note, color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radiusforbuttons),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radiusforbuttons),
                  borderSide: BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
            if (_checkingSpotify) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(minHeight: 2),
            ],
            if (_spotifyPreview != null) ...[
              const SizedBox(height: 8),
              SpotifyPreviewCard(preview: _spotifyPreview!),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusforbuttons),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Send Letter', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatVisibleAt(DateTime dt) {
    final now = DateTime.now();
    if (dt.difference(now).inMinutes.abs() < 2) return 'now';
    return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

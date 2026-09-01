import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/letter.dart';
import '../theme.dart';

/// A single letter card with a staggered fade/slide entrance animation and
/// a Hero (tagged by letter id) that the detail screen's transition grabs.
class LetterCard extends StatefulWidget {
  const LetterCard({
    super.key,
    required this.letter,
    required this.index,
    required this.onTap,
    this.showScheduledBadge = false,
  });

  final Letter letter;
  final int index;
  final VoidCallback onTap;
  final bool showScheduledBadge;

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.08),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radiusforbuttons * 2),
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusforbuttons * 2),
                  color: const Color.fromARGB(219, 214, 171, 97),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(radiusforbuttons),
                        ),
                        child: Icon(Icons.mail_outline, color: AppTheme.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Hero(
                          tag: 'letter-${letter.id}',
                          child: Material(
                            color: Colors.transparent,
                            // Flex (not Column, which doesn't expose
                            // clipBehavior) hard-clips instead of throwing a
                            // debug overflow warning when the Hero flight
                            // briefly squeezes this into a shorter box than
                            // its natural two-line height.
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Text(
                                  letter.title.isEmpty
                                      ? '(untitled letter)'
                                      : letter.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat.yMMMd().add_jm().format(letter.visibleAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.showScheduledBadge && !letter.isVisibleNow)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(radiusforbuttons),
                            ),
                            child: const Text(
                              'Scheduled',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ),
                        ),
                      const Icon(Icons.chevron_right, color: Colors.black26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

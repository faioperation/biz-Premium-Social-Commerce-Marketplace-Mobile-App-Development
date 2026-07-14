import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A self-contained comment input bar for the playback screen.
/// Manages its own TextEditingController internally to avoid parent rebuilds.
/// Exposes only delegate callbacks for sending and cancelling replies.
class PlaybackInteractiveInput extends StatefulWidget {
  /// Non-null when the seller is replying to a specific comment.
  final String? replyingToUserName;
  final String? replyingToMessage;

  final VoidCallback onCancelReply;
  final Function(String message) onSend;

  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color textSecondaryColor;

  const PlaybackInteractiveInput({
    super.key,
    this.replyingToUserName,
    this.replyingToMessage,
    required this.onCancelReply,
    required this.onSend,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.textSecondaryColor,
  });

  @override
  State<PlaybackInteractiveInput> createState() =>
      _PlaybackInteractiveInputState();
}

class _PlaybackInteractiveInputState extends State<PlaybackInteractiveInput> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final message = _textController.text.trim();
    if (message.isEmpty) return;
    widget.onSend(message);
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.cardColor,
        border: Border(top: BorderSide(color: widget.borderColor)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Reply-to banner (visible only when replying) ───────────
            if (widget.replyingToUserName != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Replying to ${widget.replyingToUserName}'
                        ': "${widget.replyingToMessage ?? ''}"',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child:
                          Icon(Icons.close, size: 14, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

            // ── Text field row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF1E1E22)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: widget.borderColor),
                    ),
                    child: TextField(
                      controller: _textController,
                      style:
                          TextStyle(color: widget.textColor, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Write a comment or reply...',
                        hintStyle: TextStyle(
                          color: widget.textSecondaryColor
                              .withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

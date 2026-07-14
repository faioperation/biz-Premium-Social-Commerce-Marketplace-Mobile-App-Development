import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import 'messenger/media_preview_bar.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String text, String? mediaPath, String? mediaType) onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _textController = TextEditingController();
  bool _hasText = false;
  String? _mediaPath;
  String? _mediaType; // 'image' | 'video'

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _canSend => _hasText || _mediaPath != null;

  void _send() {
    final text = _textController.text;
    _textController.clear();
    final path = _mediaPath;
    final type = _mediaType;
    
    setState(() {
      _hasText = false;
      _mediaPath = null;
      _mediaType = null;
    });

    widget.onSend(text, path, type);
  }

  Future<void> _pickAttachment(String type) async {
    final picker = ImagePicker();
    try {
      XFile? file;
      if (type == 'image') {
        file = await picker.pickImage(source: ImageSource.gallery);
      } else {
        file = await picker.pickVideo(source: ImageSource.gallery);
      }

      if (file != null) {
        setState(() {
          _mediaPath = file!.path;
          _mediaType = type;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Attachment Error',
        'Could not load selected file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showAttachmentMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16121E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Share Media',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.image_outlined, color: Colors.blue),
              title: const Text('Share Image', style: TextStyle(fontFamily: 'Inter')),
              onTap: () {
                Navigator.of(context).pop();
                _pickAttachment('image');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection_outlined, color: Colors.purple),
              title: const Text('Share Video', style: TextStyle(fontFamily: 'Inter')),
              onTap: () {
                Navigator.of(context).pop();
                _pickAttachment('video');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_mediaPath != null && _mediaType != null)
          MediaPreviewBar(
            path: _mediaPath!,
            type: _mediaType!,
            onRemove: () {
              setState(() {
                _mediaPath = null;
                _mediaType = null;
              });
            },
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1625) : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey[900]! : Colors.grey[200]!,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: _showAttachmentMenu,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[600] : Colors.grey[500],
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _canSend ? _send() : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedScale(
                  scale: _canSend ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: _canSend ? _send : null,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _canSend ? AppColors.primary : Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


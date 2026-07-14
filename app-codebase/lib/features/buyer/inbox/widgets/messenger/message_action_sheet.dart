import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/message_model.dart';

class MessageActionSheet extends StatelessWidget {
  final MessageModel message;
  final Function(String messageId, String newText) onEdit;
  final Function(String messageId) onDelete;

  const MessageActionSheet({
    super.key,
    required this.message,
    required this.onEdit,
    required this.onDelete,
  });

  void _showEditDialog(BuildContext context) {
    final textController = TextEditingController(text: message.text);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E2A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit Message',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: textController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Edit your message...',
              hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF8B5CF6),
                  width: 1.5,
                ),
              ),
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final trimmed = textController.text.trim();
                if (trimmed.isNotEmpty && trimmed != message.text) {
                  onEdit(message.id, trimmed);
                }
                Navigator.of(context).pop(); // Dismiss edit dialog
                Navigator.of(context).pop(); // Dismiss bottom sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canEdit = message.isMe && message.type == 'text';

    return Container(
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
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Copy option (text only)
          if (message.type == 'text')
            _buildOption(
              context: context,
              icon: Icons.copy_rounded,
              title: 'Copy Text',
              color: isDark ? Colors.white : Colors.black87,
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.text));
                Navigator.of(context).pop();
                Get.snackbar(
                  'Copied',
                  'Message copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDark ? Colors.grey[900]?.withOpacity(0.8) : Colors.black87,
                  colorText: Colors.white,
                  duration: const Duration(milliseconds: 1500),
                  margin: const EdgeInsets.all(12),
                );
              },
            ),

          // Edit option
          if (canEdit)
            _buildOption(
              context: context,
              icon: Icons.edit_outlined,
              title: 'Edit Message',
              color: isDark ? Colors.white : Colors.black87,
              onTap: () => _showEditDialog(context),
            ),

          // Delete option
          _buildOption(
            context: context,
            icon: Icons.delete_outline_rounded,
            title: message.isMe ? 'Unsend Message' : 'Delete Message',
            color: Colors.red,
            onTap: () {
              onDelete(message.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

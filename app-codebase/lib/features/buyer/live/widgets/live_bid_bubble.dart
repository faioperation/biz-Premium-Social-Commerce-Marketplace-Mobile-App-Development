import 'package:flutter/material.dart';

class LiveBidBubble extends StatelessWidget {
  final String username;
  final String text;
  final bool isBid;

  const LiveBidBubble({
    super.key,
    required this.username,
    required this.text,
    required this.isBid,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isBid
              ? Colors.orange.withValues(alpha: 0.8)
              : Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: isBid
              ? Border.all(color: Colors.amberAccent, width: 1.0)
              : null,
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(
                text: '$username ',
                style: TextStyle(
                  color: isBid ? Colors.white : Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isBid ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

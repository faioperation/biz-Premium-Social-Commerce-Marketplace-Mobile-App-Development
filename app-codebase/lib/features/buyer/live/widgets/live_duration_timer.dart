import 'dart:async';
import 'package:flutter/material.dart';

class LiveDurationTimer extends StatefulWidget {
  final TextStyle? style;
  final int? startSeconds;

  const LiveDurationTimer({
    super.key,
    this.style,
    this.startSeconds,
  });

  @override
  State<LiveDurationTimer> createState() => _LiveDurationTimerState();
}

class _LiveDurationTimerState extends State<LiveDurationTimer> {
  late int _elapsedSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start with a mock duration (e.g., around 12-25 mins) or specific starting seconds
    _elapsedSeconds = widget.startSeconds ?? (600 + (DateTime.now().second * 7) % 900);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final String hoursStr = hours.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr:$secondsStr';
    } else {
      return '$minutesStr:$secondsStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_elapsedSeconds),
      style: widget.style ?? const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
    );
  }
}

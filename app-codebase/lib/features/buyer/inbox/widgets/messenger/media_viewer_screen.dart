import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class MediaViewerScreen extends StatefulWidget {
  final String path;
  final String type; // 'image' | 'video'

  const MediaViewerScreen({
    super.key,
    required this.path,
    required this.type,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  // Video simulation states
  bool _isPlaying = false;
  double _currentSeconds = 0.0;
  final double _totalDuration = 45.0; // Simulated duration of 45 seconds
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_currentSeconds < _totalDuration) {
              _currentSeconds += 1.0;
            } else {
              _currentSeconds = 0.0;
              _isPlaying = false;
              _timer?.cancel();
            }
          });
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _seek(double value) {
    setState(() {
      _currentSeconds = value;
    });
  }

  String _formatDuration(double seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = (seconds % 60).toInt();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = widget.path.startsWith('http') || widget.path.startsWith('https');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.type == 'image' ? 'Image Viewer' : 'Video Player',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: widget.type == 'image'
            ? _buildImageViewer(isUrl)
            : _buildVideoPlayer(),
      ),
    );
  }

  Widget _buildImageViewer(bool isUrl) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      minScale: 0.5,
      maxScale: 4.0,
      child: isUrl
          ? Image.network(
              widget.path,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              },
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_rounded,
                color: Colors.white54,
                size: 64,
              ),
            )
          : Image.file(
              File(widget.path),
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_rounded,
                color: Colors.white54,
                size: 64,
              ),
            ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Simulated video screen / poster
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_creation_outlined,
                color: Colors.white.withOpacity(0.15),
                size: 100,
              ),
              const SizedBox(height: 12),
              Text(
                'Playing Video Attachment',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Custom Media Controls Overlay
        Positioned(
          bottom: 40,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slider
                Row(
                  children: [
                    Text(
                      _formatDuration(_currentSeconds),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: const Color(0xFF8B5CF6), // Premium violet color
                        inactiveColor: Colors.white24,
                        min: 0.0,
                        max: _totalDuration,
                        value: _currentSeconds,
                        onChanged: _seek,
                      ),
                    ),
                    Text(
                      _formatDuration(_totalDuration),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Controls buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                      onPressed: () {
                        setState(() {
                          _currentSeconds = (_currentSeconds - 10.0).clamp(0.0, _totalDuration);
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                      onPressed: () {
                        setState(() {
                          _currentSeconds = (_currentSeconds + 10.0).clamp(0.0, _totalDuration);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

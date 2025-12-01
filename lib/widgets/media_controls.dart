import 'package:flutter/material.dart';

class MediaControls extends StatelessWidget {
  final bool isPlaying;
  final double currentPosition;
  final String currentTimeString;
  final String totalTimeString;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSeek;
  final VoidCallback onTranslate;
  final VoidCallback onShare;
  final VoidCallback onMore;

  const MediaControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.currentTimeString,
    required this.totalTimeString,
    required this.onPlayPause,
    required this.onSeek,
    required this.onTranslate,
    required this.onShare,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: onTranslate,
                icon: const Icon(
                  Icons.translate,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: onShare,
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: onMore,
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white30,
                  thumbColor: Colors.white,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 12),
                  trackHeight: 2,
                ),
                child: Slider(
                  value: currentPosition,
                  onChanged: onSeek,
                  min: 0.0,
                  max: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTimeString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      totalTimeString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Play/Pause button
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFFE91E63),
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/subtitle_data.dart';

class SubtitleLine extends StatelessWidget {
  final SubtitleData subtitle;

  const SubtitleLine({
    super.key,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // English text
          Text(
            subtitle.english,
            style: TextStyle(
              color: Colors.white,
              fontSize: subtitle.isHighlighted ? 20 : 16,
              fontWeight:
                  subtitle.isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          // Portuguese text
          Text(
            subtitle.portuguese,
            style: TextStyle(
              color: Colors.white70,
              fontSize: subtitle.isHighlighted ? 18 : 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (!subtitle.isHighlighted) const SizedBox(height: 16),
        ],
      ),
    );
  }
}

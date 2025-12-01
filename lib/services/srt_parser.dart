import 'dart:io';
import '../models/subtitle_data.dart';

class SrtParser {
  static Future<List<SubtitleData>> parseSrtFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      return parseSrtContent(content);
    } catch (e) {
      print('Error reading SRT file: $e');
      return [];
    }
  }

  static List<SubtitleData> parseSrtContent(String content) {
    final List<SubtitleData> subtitles = [];
    final blocks = content.split('\n\n');

    for (final block in blocks) {
      final lines = block.trim().split('\n');
      if (lines.length >= 3) {
        try {
          // Skip the subtitle number (first line)
          final timeLine = lines[1];
          final textLines = lines.sublist(2);

          final times = _parseTimeLine(timeLine);
          if (times != null) {
            subtitles.add(SubtitleData(
              english: textLines.join('\n'),
              portuguese: '', // Will be populated from Portuguese SRT
              startTime: times['start']!,
              endTime: times['end']!,
            ));
          }
        } catch (e) {
          print('Error parsing subtitle block: $e');
        }
      }
    }

    return subtitles;
  }

  static Map<String, double>? _parseTimeLine(String timeLine) {
    try {
      // Format: 00:00:20,000 --> 00:00:24,400
      final parts = timeLine.split(' --> ');
      if (parts.length != 2) return null;

      final startTime = _parseTimeString(parts[0].trim());
      final endTime = _parseTimeString(parts[1].trim());

      if (startTime != null && endTime != null) {
        return {'start': startTime, 'end': endTime};
      }
    } catch (e) {
      print('Error parsing time line: $e');
    }
    return null;
  }

  static double? _parseTimeString(String timeString) {
    try {
      // Format: 00:00:20,400
      final parts = timeString.split(':');
      if (parts.length != 3) return null;

      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      final secondsParts = parts[2].split(',');
      final seconds = int.parse(secondsParts[0]);
      final milliseconds = int.parse(secondsParts[1]);

      return hours * 3600.0 + minutes * 60.0 + seconds + milliseconds / 1000.0;
    } catch (e) {
      print('Error parsing time string: $e');
      return null;
    }
  }

  static Future<List<SubtitleData>> mergeSubtitles({
    required String primaryFilePath,
    required String secondaryFilePath,
  }) async {
    final primarySubtitles = await parseSrtFile(primaryFilePath);
    final secondarySubtitles = await parseSrtFile(secondaryFilePath);

    // Merge subtitles by matching timestamps
    final mergedSubtitles = <SubtitleData>[];

    for (int i = 0; i < primarySubtitles.length; i++) {
      final primary = primarySubtitles[i];
      String secondaryText = '';

      // Find matching subtitle in secondary file
      for (final secondary in secondarySubtitles) {
        if (_isTimeMatch(primary.startTime, secondary.startTime)) {
          secondaryText =
              secondary.english; // Using english field for secondary language
          break;
        }
      }

      mergedSubtitles.add(SubtitleData(
        english: primary.english,
        portuguese: secondaryText,
        startTime: primary.startTime,
        endTime: primary.endTime,
      ));
    }

    return mergedSubtitles;
  }

  static bool _isTimeMatch(double time1, double time2,
      {double tolerance = 0.5}) {
    return (time1 - time2).abs() <= tolerance;
  }
}

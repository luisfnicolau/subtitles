import 'subtitle_file.dart';

class MediaItem {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final double duration;
  final String audioFilePath;
  final List<SubtitleFile> subtitleFiles;

  MediaItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.duration,
    required this.audioFilePath,
    this.subtitleFiles = const [],
  });

  MediaItem copyWith({
    String? id,
    String? title,
    String? artist,
    String? imageUrl,
    double? duration,
    String? audioFilePath,
    List<SubtitleFile>? subtitleFiles,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      subtitleFiles: subtitleFiles ?? this.subtitleFiles,
    );
  }

  bool get hasSubtitles => subtitleFiles.isNotEmpty;

  List<String> get availableLanguages =>
      subtitleFiles.map((file) => file.language).toList();
}

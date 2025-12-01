class SubtitleFile {
  final String language;
  final String languageCode;
  final String filePath;
  final DateTime lastModified;

  SubtitleFile({
    required this.language,
    required this.languageCode,
    required this.filePath,
    required this.lastModified,
  });

  factory SubtitleFile.fromPath(String filePath) {
    final fileName = filePath.split('/').last;
    final parts = fileName.split('.');

    // Expected format: song_title.en.srt, song_title.pt.srt, etc.
    String languageCode = 'en'; // default
    String language = 'English'; // default

    if (parts.length >= 3) {
      languageCode = parts[parts.length - 2];
      language = _getLanguageName(languageCode);
    }

    return SubtitleFile(
      language: language,
      languageCode: languageCode,
      filePath: filePath,
      lastModified: DateTime.now(),
    );
  }

  static String _getLanguageName(String code) {
    final Map<String, String> languageMap = {
      'en': 'English',
      'pt': 'Portuguese',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'ru': 'Russian',
      'ar': 'Arabic',
    };
    return languageMap[code] ?? code.toUpperCase();
  }
}

class SubtitleData {
  final String english;
  final String portuguese;
  final double startTime;
  final double endTime;
  final bool isHighlighted;

  SubtitleData({
    required this.english,
    required this.portuguese,
    required this.startTime,
    required this.endTime,
    this.isHighlighted = false,
  });
}

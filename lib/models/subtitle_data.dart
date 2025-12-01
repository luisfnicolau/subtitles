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

  SubtitleData copyWith({
    String? english,
    String? portuguese,
    double? startTime,
    double? endTime,
    bool? isHighlighted,
  }) {
    return SubtitleData(
      english: english ?? this.english,
      portuguese: portuguese ?? this.portuguese,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

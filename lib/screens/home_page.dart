import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/subtitle_line.dart';
import '../widgets/media_controls.dart';
import '../models/subtitle_data.dart';
import '../models/media_item.dart';
import '../services/srt_parser.dart';

class HomePage extends StatefulWidget {
  final MediaItem media;

  const HomePage({super.key, required this.media});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double currentPosition = 0.0;
  late double totalDuration;
  List<SubtitleData> subtitles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    totalDuration = widget.media.duration;
    _initializeAudio();
    _loadSubtitles();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    try {
      // Set the audio source
      if (widget.media.audioFilePath.startsWith('assets/')) {
        await _audioPlayer.setAsset(widget.media.audioFilePath);
      } else {
        await _audioPlayer.setFilePath(widget.media.audioFilePath);
      }

      // Listen to position changes
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            currentPosition = position.inMilliseconds / 1000.0;
          });
        }
      });

      // Listen to duration changes
      _audioPlayer.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() {
            totalDuration = duration.inMilliseconds / 1000.0;
          });
        }
      });

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state.playing;
          });
        }
      });
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> _loadSubtitles() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (widget.media.subtitleFiles.isNotEmpty) {
        // Load subtitles from the media's subtitle files
        final englishFile = widget.media.subtitleFiles
            .where((file) => file.languageCode == 'en')
            .firstOrNull;
        final portugueseFile = widget.media.subtitleFiles
            .where((file) => file.languageCode == 'pt')
            .firstOrNull;

        if (englishFile != null && portugueseFile != null) {
          // For web, try to load from assets directly
          try {
            final englishContent =
                await rootBundle.loadString(englishFile.filePath);
            final portugueseContent =
                await rootBundle.loadString(portugueseFile.filePath);

            final englishSubtitles = SrtParser.parseSrtContent(englishContent);
            final portugueseSubtitles =
                SrtParser.parseSrtContent(portugueseContent);

            // Merge by matching timestamps
            final mergedSubtitles = <SubtitleData>[];
            for (int i = 0; i < englishSubtitles.length; i++) {
              final english = englishSubtitles[i];
              final portuguese = i < portugueseSubtitles.length
                  ? portugueseSubtitles[i]
                  : null;

              mergedSubtitles.add(SubtitleData(
                english: english.english,
                portuguese: portuguese?.english ??
                    '', // Using english field for Portuguese content
                startTime: english.startTime,
                endTime: english.endTime,
              ));
            }

            setState(() {
              subtitles = mergedSubtitles;
            });
          } catch (e) {
            print('Error loading subtitle content: $e');
            _loadSampleSubtitles();
          }
        } else if (englishFile != null) {
          // Load only English subtitles
          try {
            final content = await rootBundle.loadString(englishFile.filePath);
            final parsedSubtitles = SrtParser.parseSrtContent(content);
            setState(() {
              subtitles = parsedSubtitles;
            });
          } catch (e) {
            print('Error loading English subtitles: $e');
            _loadSampleSubtitles();
          }
        } else {
          // Use sample subtitles if no files found
          _loadSampleSubtitles();
        }
      } else {
        // Use sample subtitles if no subtitle files
        _loadSampleSubtitles();
      }
    } catch (e) {
      print('Error loading subtitles: $e');
      _loadSampleSubtitles();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadSampleSubtitles() {
    subtitles = [
      SubtitleData(
        english: "Flashing your favorite point of view",
        portuguese: "Exibindo seu ponto de vista favorito",
        startTime: 0.0,
        endTime: 3.0,
      ),
      SubtitleData(
        english: "I know you're waiting in the distance",
        portuguese: "Eu sei que você está esperando à distância",
        startTime: 8.0,
        endTime: 12.0,
      ),
      SubtitleData(
        english: "Just like you always do, just like you always do",
        portuguese: "Como você sempre faz, como você sempre faz",
        startTime: 15.0,
        endTime: 20.0,
        isHighlighted: true,
      ),
      SubtitleData(
        english: "Already pulling me in, already under my skin",
        portuguese: "Já me puxando, já debaixo da minha pele",
        startTime: 25.0,
        endTime: 30.0,
      ),
      SubtitleData(
        english: "And I know exactly how this ends",
        portuguese: "E eu sei exatamente como isso termina",
        startTime: 35.0,
        endTime: 40.0,
      ),
    ];
  }

  Future<void> _togglePlayback() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error toggling playback: $e');
    }
  }

  Future<void> _seekTo(double position) async {
    try {
      final duration =
          Duration(milliseconds: (position * totalDuration * 1000).round());
      await _audioPlayer.seek(duration);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  SubtitleData? get currentSubtitle {
    for (final subtitle in subtitles) {
      if (currentPosition >= subtitle.startTime &&
          currentPosition <= subtitle.endTime) {
        return subtitle;
      }
    }
    return null;
  }

  List<SubtitleData> get displaySubtitles {
    return subtitles.map((subtitle) {
      return subtitle.copyWith(
        isHighlighted: currentPosition >= subtitle.startTime &&
            currentPosition <= subtitle.endTime,
      );
    }).toList();
  }

  String get currentTimeString {
    int minutes = currentPosition.floor() ~/ 60;
    int seconds = (currentPosition.floor() % 60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  String get totalTimeString {
    int minutes = totalDuration.floor() ~/ 60;
    int seconds = (totalDuration.floor() % 60);
    return "-$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB968C7),
              Color(0xFFE91E63),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              // Song info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      widget.media.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.media.artist,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Subtitles
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ListView.builder(
                          itemCount: displaySubtitles.length,
                          itemBuilder: (context, index) {
                            return SubtitleLine(
                              subtitle: displaySubtitles[index],
                            );
                          },
                        ),
                      ),
              ),

              // Media Controls
              MediaControls(
                isPlaying: isPlaying,
                currentPosition:
                    totalDuration > 0 ? currentPosition / totalDuration : 0.0,
                currentTimeString: currentTimeString,
                totalTimeString: totalTimeString,
                onPlayPause: _togglePlayback,
                onSeek: _seekTo,
                onTranslate: () {
                  // Handle translate button
                },
                onShare: () {
                  // Handle share button
                },
                onMore: () {
                  // Handle more options
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

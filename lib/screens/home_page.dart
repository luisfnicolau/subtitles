import 'package:flutter/material.dart';
import '../widgets/subtitle_line.dart';
import '../widgets/media_controls.dart';
import '../models/subtitle_data.dart';
import '../models/media_item.dart';

class HomePage extends StatefulWidget {
  final MediaItem media;

  const HomePage({super.key, required this.media});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false;
  double currentPosition = 0.17; // 0:17 as shown in screenshot
  late double totalDuration;

  @override
  void initState() {
    super.initState();
    totalDuration = widget.media.duration;
  }

  // Sample subtitle data - you can replace this with real data
  final List<SubtitleData> subtitles = [
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

  String get currentTimeString {
    int minutes = (currentPosition * totalDuration * 60).floor() ~/ 60;
    int seconds = ((currentPosition * totalDuration * 60).floor() % 60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  String get totalTimeString {
    int minutes = (totalDuration * 60).floor() ~/ 60;
    int seconds = ((totalDuration * 60).floor() % 60);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListView.builder(
                    itemCount: subtitles.length,
                    itemBuilder: (context, index) {
                      return SubtitleLine(
                        subtitle: subtitles[index],
                      );
                    },
                  ),
                ),
              ),

              // Media Controls
              MediaControls(
                isPlaying: isPlaying,
                currentPosition: currentPosition,
                currentTimeString: currentTimeString,
                totalTimeString: totalTimeString,
                onPlayPause: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                onSeek: (value) {
                  setState(() {
                    currentPosition = value;
                  });
                },
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

import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../services/media_library_service.dart';
import '../widgets/import_media_dialog.dart';
import 'home_page.dart';

class MediaListPage extends StatefulWidget {
  const MediaListPage({super.key});

  @override
  State<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  List<MediaItem> mediaItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMediaLibrary();
  }

  Future<void> _loadMediaLibrary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final items = await MediaLibraryService.getMediaLibrary();

      // Add sample items if library is empty
      if (items.isEmpty) {
        items.addAll(_getSampleMediaItems());
      }

      setState(() {
        mediaItems = items;
      });
    } catch (e) {
      print('Error loading media library: $e');
      setState(() {
        mediaItems = _getSampleMediaItems();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<MediaItem> _getSampleMediaItems() {
    return [
      MediaItem(
        id: '1',
        title: 'The Emptiness Machine',
        artist: 'Linkin Park',
        imageUrl: 'https://via.placeholder.com/300x300/B968C7/FFFFFF?text=LP',
        duration: 2.52,
        audioFilePath: '',
      ),
      MediaItem(
        id: '2',
        title: 'Heavy Is The Crown',
        artist: 'Linkin Park',
        imageUrl: 'https://via.placeholder.com/300x300/E91E63/FFFFFF?text=LP',
        duration: 3.24,
        audioFilePath: '',
      ),
      MediaItem(
        id: '3',
        title: 'Over Each Other',
        artist: 'Linkin Park',
        imageUrl: 'https://via.placeholder.com/300x300/9C27B0/FFFFFF?text=LP',
        duration: 2.48,
        audioFilePath: '',
      ),
      MediaItem(
        id: '4',
        title: 'Casualty',
        artist: 'Linkin Park',
        imageUrl: 'https://via.placeholder.com/300x300/673AB7/FFFFFF?text=LP',
        duration: 3.15,
        audioFilePath: '',
      ),
      MediaItem(
        id: '5',
        title: 'Overflow',
        artist: 'Linkin Park',
        imageUrl: 'https://via.placeholder.com/300x300/3F51B5/FFFFFF?text=LP',
        duration: 2.33,
        audioFilePath: '',
      ),
    ];
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => ImportMediaDialog(
        onMediaImported: (mediaItem) {
          setState(() {
            mediaItems.add(mediaItem);
          });
        },
      ),
    );
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
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Media Library',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _showImportDialog,
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select a song to view lyrics',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Media List
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : mediaItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.library_music,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No media files found',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the + button to import your first song',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: mediaItems.length,
                            itemBuilder: (context, index) {
                              final media = mediaItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: MediaItemCard(
                                  media: media,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(media: media),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaItemCard extends StatelessWidget {
  final MediaItem media;
  final VoidCallback onTap;

  const MediaItemCard({
    super.key,
    required this.media,
    required this.onTap,
  });

  String get durationString {
    int minutes = media.duration.floor();
    int seconds = ((media.duration - minutes) * 60).round();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Album Art
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  media.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB968C7),
                            Color(0xFFE91E63),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    durationString,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  if (media.hasSubtitles) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.subtitles,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          media.availableLanguages.join(', '),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Play Arrow
            Icon(
              Icons.play_arrow,
              color: Colors.white.withOpacity(0.7),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

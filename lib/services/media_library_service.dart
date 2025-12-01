import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/media_item.dart';
import '../models/subtitle_file.dart';

class MediaLibraryService {
  static const String _mediaFolderName = 'media_library';

  static Future<Directory> get _mediaDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${appDir.path}/$_mediaFolderName');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  static Future<List<MediaItem>> getMediaLibrary() async {
    final mediaDir = await _mediaDirectory;
    final List<MediaItem> mediaItems = [];

    await for (final entity in mediaDir.list()) {
      if (entity is Directory) {
        final mediaItem = await _loadMediaItem(entity);
        if (mediaItem != null) {
          mediaItems.add(mediaItem);
        }
      }
    }

    return mediaItems;
  }

  static Future<MediaItem?> _loadMediaItem(Directory itemDir) async {
    String? audioFile;
    final List<SubtitleFile> subtitleFiles = [];

    await for (final file in itemDir.list()) {
      if (file is File) {
        final fileName = file.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        if (_isAudioFile(extension)) {
          audioFile = file.path;
        } else if (extension == 'srt') {
          subtitleFiles.add(SubtitleFile.fromPath(file.path));
        }
      }
    }

    if (audioFile == null) return null;

    final folderName = itemDir.path.split('/').last;
    final parts = folderName.split(' - ');

    return MediaItem(
      id: folderName,
      title: parts.length > 1 ? parts[1] : folderName,
      artist: parts.isNotEmpty ? parts[0] : 'Unknown Artist',
      imageUrl: '', // Will be set from audio metadata or placeholder
      duration: 3.0, // Will be extracted from audio file
      audioFilePath: audioFile,
      subtitleFiles: subtitleFiles,
    );
  }

  static bool _isAudioFile(String extension) {
    const audioExtensions = ['mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'];
    return audioExtensions.contains(extension);
  }

  static Future<String?> importAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }
    } catch (e) {
      print('Error picking audio file: $e');
    }
    return null;
  }

  static Future<List<String>?> importSubtitleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['srt'],
        allowMultiple: true,
      );

      if (result != null) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList();
      }
    } catch (e) {
      print('Error picking subtitle files: $e');
    }
    return null;
  }

  static Future<MediaItem?> createMediaItem({
    required String audioPath,
    required String title,
    required String artist,
    List<String> subtitlePaths = const [],
  }) async {
    try {
      final mediaDir = await _mediaDirectory;
      final itemId =
          '${artist.replaceAll(' ', '_')} - ${title.replaceAll(' ', '_')}';
      final itemDir = Directory('${mediaDir.path}/$itemId');

      if (!await itemDir.exists()) {
        await itemDir.create(recursive: true);
      }

      // Copy audio file
      final audioFile = File(audioPath);
      final audioExtension = audioPath.split('.').last;
      final newAudioPath = '${itemDir.path}/$title.$audioExtension';
      await audioFile.copy(newAudioPath);

      // Copy subtitle files
      final List<SubtitleFile> subtitleFiles = [];
      for (final subtitlePath in subtitlePaths) {
        final subtitleFile = File(subtitlePath);
        final originalName = subtitlePath.split('/').last;
        final newSubtitlePath = '${itemDir.path}/$originalName';
        await subtitleFile.copy(newSubtitlePath);
        subtitleFiles.add(SubtitleFile.fromPath(newSubtitlePath));
      }

      return MediaItem(
        id: itemId,
        title: title,
        artist: artist,
        imageUrl: '', // Placeholder
        duration: 3.0, // Will be extracted from audio file
        audioFilePath: newAudioPath,
        subtitleFiles: subtitleFiles,
      );
    } catch (e) {
      print('Error creating media item: $e');
      return null;
    }
  }

  static Future<bool> deleteMediaItem(String itemId) async {
    try {
      final mediaDir = await _mediaDirectory;
      final itemDir = Directory('${mediaDir.path}/$itemId');

      if (await itemDir.exists()) {
        await itemDir.delete(recursive: true);
        return true;
      }
    } catch (e) {
      print('Error deleting media item: $e');
    }
    return false;
  }
}

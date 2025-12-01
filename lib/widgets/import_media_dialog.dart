import 'package:flutter/material.dart';
import '../services/media_library_service.dart';
import '../models/media_item.dart';

class ImportMediaDialog extends StatefulWidget {
  final Function(MediaItem) onMediaImported;

  const ImportMediaDialog({
    super.key,
    required this.onMediaImported,
  });

  @override
  State<ImportMediaDialog> createState() => _ImportMediaDialogState();
}

class _ImportMediaDialogState extends State<ImportMediaDialog> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  String? _selectedAudioPath;
  List<String> _selectedSubtitlePaths = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    final audioPath = await MediaLibraryService.importAudioFile();
    if (audioPath != null) {
      setState(() {
        _selectedAudioPath = audioPath;
        // Auto-fill title from filename if empty
        if (_titleController.text.isEmpty) {
          final filename = audioPath.split('/').last;
          final nameWithoutExtension = filename.split('.').first;
          _titleController.text = nameWithoutExtension.replaceAll('_', ' ');
        }
      });
    }
  }

  Future<void> _pickSubtitleFiles() async {
    final subtitlePaths = await MediaLibraryService.importSubtitleFiles();
    if (subtitlePaths != null) {
      setState(() {
        _selectedSubtitlePaths = subtitlePaths;
      });
    }
  }

  Future<void> _importMedia() async {
    if (_selectedAudioPath == null ||
        _titleController.text.trim().isEmpty ||
        _artistController.text.trim().isEmpty) {
      _showErrorDialog(
          'Please fill in all required fields and select an audio file.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final mediaItem = await MediaLibraryService.createMediaItem(
      audioPath: _selectedAudioPath!,
      title: _titleController.text.trim(),
      artist: _artistController.text.trim(),
      subtitlePaths: _selectedSubtitlePaths,
    );

    setState(() {
      _isLoading = false;
    });

    if (mediaItem != null) {
      widget.onMediaImported(mediaItem);
      Navigator.of(context).pop();
    } else {
      _showErrorDialog('Failed to import media. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Import Media',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Title Field
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Song Title*',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Artist Field
            TextField(
              controller: _artistController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Artist*',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Audio File Selection
            _buildFileSection(
              title: 'Audio File*',
              subtitle: _selectedAudioPath != null
                  ? _selectedAudioPath!.split('/').last
                  : 'No audio file selected',
              icon: Icons.music_note,
              onTap: _pickAudioFile,
              hasFile: _selectedAudioPath != null,
            ),

            const SizedBox(height: 16),

            // Subtitle Files Selection
            _buildFileSection(
              title: 'Subtitle Files (.srt)',
              subtitle: _selectedSubtitlePaths.isEmpty
                  ? 'No subtitle files selected'
                  : '${_selectedSubtitlePaths.length} file(s) selected',
              icon: Icons.subtitles,
              onTap: _pickSubtitleFiles,
              hasFile: _selectedSubtitlePaths.isNotEmpty,
            ),

            if (_selectedSubtitlePaths.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...(_selectedSubtitlePaths.map((path) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text(
                      '• ${path.split('/').last}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ))),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _importMedia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB968C7),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Import',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: hasFile
                ? const Color(0xFFB968C7)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: hasFile
                  ? const Color(0xFFB968C7)
                  : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

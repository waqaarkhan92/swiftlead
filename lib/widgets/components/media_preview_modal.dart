import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/error_state_card.dart';
import '../global/frosted_container.dart';

/// Media Preview Modal - Full-screen media viewer
/// Exact specification from UI_Inventory_v2.5.1
class MediaPreviewModal extends StatelessWidget {
  final String mediaUrl;
  final String? mediaType; // 'image', 'video', 'document'
  final String? fileName;

  const MediaPreviewModal({
    super.key,
    required this.mediaUrl,
    this.mediaType,
    this.fileName,
  });

  static void show({
    required BuildContext context,
    required String mediaUrl,
    String? mediaType,
    String? fileName,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => MediaPreviewModal(
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        fileName: fileName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detectedType = mediaType ?? _detectMediaType(mediaUrl);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              // Download media
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share media
            },
          ),
        ],
      ),
      body: Center(
        child: _buildMediaViewer(context, detectedType),
      ),
    );
  }

  Widget _buildMediaViewer(BuildContext context, String type) {
    switch (type) {
      case 'image':
        return _buildImageViewer(context);
      case 'video':
        return _buildVideoViewer(context);
      default:
        return ErrorStateCard(
          title: 'Unsupported Media Type',
          description: 'This media type cannot be previewed.',
          icon: Icons.error_outline,
        );
    }
  }

  Widget _buildImageViewer(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Image.network(
        mediaUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return ErrorStateCard(
            title: 'Failed to load media',
            description: 'Unable to load the image. Please try again.',
            icon: Icons.broken_image,
            actionLabel: 'Retry',
            onAction: () {
              // Retry loading
            },
          );
        },
      ),
    );
  }

  Widget _buildVideoViewer(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'Video Preview',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            if (fileName != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                fileName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
            const SizedBox(height: SwiftleadTokens.spaceL),
            ElevatedButton.icon(
              onPressed: () {
                // Open video player
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Video'),
            ),
          ],
        ),
      ),
    );
  }

  String _detectMediaType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.jpg') || lowerUrl.contains('.jpeg') || 
        lowerUrl.contains('.png') || lowerUrl.contains('.gif') ||
        lowerUrl.contains('.webp')) {
      return 'image';
    } else if (lowerUrl.contains('.mp4') || lowerUrl.contains('.mov') ||
               lowerUrl.contains('.avi') || lowerUrl.contains('.webm')) {
      return 'video';
    } else {
      return 'document';
    }
  }
}


import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// MediaThumbnail - Public component extracted from JobDetailScreen
/// Exact specification from UI_Inventory_v2.5.1
class MediaThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String? label;
  final VoidCallback onTap;

  const MediaThumbnail({
    super.key,
    this.imageUrl,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.05)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
                ),
              )
            else
              _buildPlaceholder(context),
            if (label != null)
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.photo,
        size: 32,
        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
      ),
    );
  }
}


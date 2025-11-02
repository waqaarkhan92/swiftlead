import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// LinkPreviewCard - Rich preview of URLs sent in messages
/// Exact specification from UI_Inventory_v2.5.1
class LinkPreviewCard extends StatelessWidget {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final bool isOutbound;
  final VoidCallback? onTap;

  const LinkPreviewCard({
    super.key,
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.isOutbound = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = isOutbound
        ? Colors.white.withOpacity(0.15)
        : (brightness == Brightness.light
            ? Colors.black.withOpacity(0.06)
            : Colors.white.withOpacity(0.1));

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOutbound
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preview image
            if (imageUrl != null)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: imageUrl!.startsWith('http')
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: const Icon(
                          Icons.link,
                          color: Colors.grey,
                        ),
                      ),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site name / URL
                  if (siteName != null || url.isNotEmpty) ...[
                    Text(
                      siteName ?? _extractDomain(url),
                      style: TextStyle(
                        color: isOutbound
                            ? Colors.white.withOpacity(0.8)
                            : Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                  ],
                  
                  // Title
                  if (title != null) ...[
                    Text(
                      title!,
                      style: TextStyle(
                        color: isOutbound
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                  
                  // Description
                  if (description != null) ...[
                    Text(
                      description!,
                      style: TextStyle(
                        color: isOutbound
                            ? Colors.white.withOpacity(0.9)
                            : Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return url;
    }
  }
}


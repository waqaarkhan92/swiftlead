import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ChannelIconBadge - Channel logo with tooltip
/// Exact specification from UI_Inventory_v2.5.1
class ChannelIconBadge extends StatelessWidget {
  final String channel;
  final double size;
  
  const ChannelIconBadge({
    super.key,
    required this.channel,
    this.size = 20,
  });

  IconData _getChannelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'sms':
        return Icons.sms;
      case 'whatsapp':
        return Icons.chat_bubble;
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'email':
        return Icons.email;
      default:
        return Icons.message;
    }
  }

  Color _getChannelColor(String channel) {
    switch (channel.toLowerCase()) {
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'email':
        return const Color(SwiftleadTokens.primaryTeal);
      default:
        return const Color(SwiftleadTokens.primaryTeal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getChannelColor(channel);
    
    return Tooltip(
      message: channel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Icon(
          _getChannelIcon(channel),
          size: size * 0.7,
          color: color,
        ),
      ),
    );
  }
}


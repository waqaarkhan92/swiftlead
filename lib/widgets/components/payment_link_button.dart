import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/toast.dart';

/// PaymentLinkButton - Component for generating/copying payment links
/// Exact specification from UI_Inventory_v2.5.1
class PaymentLinkButton extends StatefulWidget {
  final String paymentLink;
  final VoidCallback? onShare;
  final bool showCopyButton;
  final bool isCompact;

  const PaymentLinkButton({
    super.key,
    required this.paymentLink,
    this.onShare,
    this.showCopyButton = true,
    this.isCompact = false,
  });

  @override
  State<PaymentLinkButton> createState() => _PaymentLinkButtonState();
}

class _PaymentLinkButtonState extends State<PaymentLinkButton> {
  bool _isCopied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.paymentLink));
    setState(() => _isCopied = true);
    
    if (mounted) {
      Toast.show(
        context,
        message: 'Payment link copied to clipboard',
        type: ToastType.success,
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isCopied = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return PrimaryButton(
        label: _isCopied ? 'Copied!' : 'Copy Payment Link',
        onPressed: _isCopied ? null : _copyToClipboard,
        icon: _isCopied ? Icons.check : Icons.link,
        size: ButtonSize.small,
      );
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                color: const Color(SwiftleadTokens.primaryTeal),
                size: 24,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  'Payment Link',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Payment Link Display
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.paymentLink,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.grey.shade600,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (widget.showCopyButton)
                  IconButton(
                    icon: Icon(
                      _isCopied ? Icons.check : Icons.copy,
                      size: 18,
                      color: _isCopied
                          ? const Color(SwiftleadTokens.successGreen)
                          : const Color(SwiftleadTokens.primaryTeal),
                    ),
                    onPressed: _isCopied ? null : _copyToClipboard,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Action Buttons
          Row(
            children: [
              if (widget.showCopyButton)
                Expanded(
                  child: PrimaryButton(
                    label: _isCopied ? 'Copied!' : 'Copy Link',
                    onPressed: _isCopied ? null : _copyToClipboard,
                    icon: _isCopied ? Icons.check : Icons.copy,
                    size: ButtonSize.medium,
                  ),
                ),
              if (widget.showCopyButton && widget.onShare != null)
                const SizedBox(width: SwiftleadTokens.spaceS),
              if (widget.onShare != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(SwiftleadTokens.primaryTeal),
                      side: const BorderSide(color: Color(SwiftleadTokens.primaryTeal)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// PrimaryButton helper class
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final height = size == ButtonSize.small ? 36.0 : 48.0;
    final fontSize = size == ButtonSize.small ? 14.0 : 16.0;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

enum ButtonSize {
  small,
  medium,
  large,
}


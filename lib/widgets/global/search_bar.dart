import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// SearchBar - Global search input with auto-complete
/// Exact specification from UI_Inventory_v2.5.1
class SwiftleadSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<String>? recentSearches;
  final List<String>? suggestions;
  final VoidCallback? onClear;
  final TextEditingController? controller;

  const SwiftleadSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.recentSearches,
    this.suggestions,
    this.onClear,
    this.controller,
  });

  @override
  State<SwiftleadSearchBar> createState() => _SwiftleadSearchBarState();
}

class _SwiftleadSearchBarState extends State<SwiftleadSearchBar> {
  late final TextEditingController _controller;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
      widget.onChanged?.call(_controller.text);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (focused) {
            setState(() => _isFocused = focused);
          },
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Search...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onClear?.call();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: Color(SwiftleadTokens.primaryTeal),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white.withOpacity(0.88)
                  : const Color(0xFF131516).withOpacity(0.78),
            ),
            onSubmitted: widget.onSubmitted,
            textInputAction: TextInputAction.search,
          ),
        ),
        
        // Suggestions/Recent searches
        if (_isFocused && (widget.suggestions != null || widget.recentSearches != null))
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.recentSearches != null && widget.recentSearches!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Recent Searches',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...widget.recentSearches!.map((search) => ListTile(
                    leading: const Icon(Icons.history, size: 20),
                    title: Text(search),
                    onTap: () {
                      _controller.text = search;
                      widget.onSubmitted?.call(search);
                    },
                  )),
                ],
                if (widget.suggestions != null && widget.suggestions!.isNotEmpty) ...[
                  if (widget.recentSearches != null && widget.recentSearches!.isNotEmpty)
                    const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Suggestions',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...widget.suggestions!.map((suggestion) => ListTile(
                    leading: const Icon(Icons.search, size: 20),
                    title: Text(suggestion),
                    onTap: () {
                      _controller.text = suggestion;
                      widget.onSubmitted?.call(suggestion);
                    },
                  )),
                ],
              ],
            ),
          ),
      ],
    );
  }
}


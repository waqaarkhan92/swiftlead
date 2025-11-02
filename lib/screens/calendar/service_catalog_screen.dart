import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';

/// Service Catalog Screen - Browse and select services for bookings
/// Exact specification from UI_Inventory_v2.5.1
class ServiceCatalogScreen extends StatefulWidget {
  final Function(String serviceId, String serviceName)? onServiceSelected;
  
  const ServiceCatalogScreen({
    super.key,
    this.onServiceSelected,
  });

  @override
  State<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends State<ServiceCatalogScreen> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedServiceId;

  final List<String> _categories = ['All', 'Repairs', 'Installation', 'Maintenance', 'Consultation'];
  final List<_ServiceItem> _services = [
    _ServiceItem(
      id: '1',
      name: 'Kitchen Sink Repair',
      category: 'Repairs',
      duration: 60,
      price: 150.0,
      description: 'Full repair service for kitchen sink issues',
    ),
    _ServiceItem(
      id: '2',
      name: 'Bathroom Installation',
      category: 'Installation',
      duration: 240,
      price: 500.0,
      description: 'Complete bathroom installation service',
    ),
    _ServiceItem(
      id: '3',
      name: 'Heating System Check',
      category: 'Maintenance',
      duration: 90,
      price: 100.0,
      description: 'Annual heating system maintenance check',
    ),
    _ServiceItem(
      id: '4',
      name: 'Electrical Consultation',
      category: 'Consultation',
      duration: 30,
      price: 50.0,
      description: 'Professional electrical consultation',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ServiceItem> get _filteredServices {
    var filtered = _services;
    
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered.where((s) => s.category == _selectedCategory).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((s) =>
          s.name.toLowerCase().contains(query) ||
          s.description.toLowerCase().contains(query)
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Select Service',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 120,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    final filteredServices = _filteredServices;

    if (filteredServices.isEmpty && !_isLoading) {
      return EmptyStateCard(
        title: 'No services found',
        description: _searchController.text.isNotEmpty
            ? 'Try a different search term'
            : 'Add services to get started',
        icon: Icons.search_off,
        actionLabel: 'Add Service',
        onAction: () {
          // Navigate to service editor
        },
      );
    }

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: SwiftleadSearchBar(
            controller: _searchController,
            hintText: 'Search services...',
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),

        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                child: SwiftleadChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : category;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),

        // Services List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              ...filteredServices.map((service) => Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: _ServiceCard(
                  service: service,
                  isSelected: _selectedServiceId == service.id,
                  onTap: () {
                    setState(() {
                      _selectedServiceId = service.id;
                    });
                  },
                  onSelect: () {
                    widget.onServiceSelected?.call(service.id, service.name);
                    Navigator.of(context).pop();
                  },
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceItem {
  final String id;
  final String name;
  final String category;
  final int duration; // minutes
  final double price;
  final String description;

  _ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.price,
    required this.description,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem service;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSelect;

  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
    required this.onSelect,
  });

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '$hours ${mins}min' : '${hours}h';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        backgroundColor: isSelected
            ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(SwiftleadTokens.primaryTeal),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(service.duration),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Icon(
                  Icons.attach_money,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  '£${service.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  PrimaryButton(
                    label: 'Select',
                    onPressed: onSelect,
                    size: ButtonSize.small,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


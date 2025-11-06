import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Resource Management Screen - Track equipment/room availability
/// v2.5.1 Enhancement: Equipment and room tracking
class ResourceManagementScreen extends StatefulWidget {
  const ResourceManagementScreen({super.key});

  @override
  State<ResourceManagementScreen> createState() => _ResourceManagementScreenState();
}

class _ResourceManagementScreenState extends State<ResourceManagementScreen> {
  String _selectedCategory = 'all'; // all, equipment, rooms

  // Mock resources data
  List<Resource> _resources = [
    Resource(
      id: '1',
      name: 'Van 1',
      category: ResourceCategory.equipment,
      status: ResourceStatus.available,
      currentBookingId: null,
    ),
    Resource(
      id: '2',
      name: 'Van 2',
      category: ResourceCategory.equipment,
      status: ResourceStatus.inUse,
      currentBookingId: 'booking-1',
      currentBookingName: 'John Smith - Boiler Service',
    ),
    Resource(
      id: '3',
      name: 'Equipment Set A',
      category: ResourceCategory.equipment,
      status: ResourceStatus.available,
      currentBookingId: null,
    ),
    Resource(
      id: '4',
      name: 'Room A',
      category: ResourceCategory.room,
      status: ResourceStatus.available,
      currentBookingId: null,
    ),
    Resource(
      id: '5',
      name: 'Room B',
      category: ResourceCategory.room,
      status: ResourceStatus.inUse,
      currentBookingId: 'booking-2',
      currentBookingName: 'Sarah Williams - Consultation',
    ),
    Resource(
      id: '6',
      name: 'Workshop',
      category: ResourceCategory.room,
      status: ResourceStatus.maintenance,
      currentBookingId: null,
      notes: 'Maintenance scheduled until end of week',
    ),
  ];

  List<Resource> get _filteredResources {
    if (_selectedCategory == 'all') return _resources;
    return _resources.where((r) {
      if (_selectedCategory == 'equipment') return r.category == ResourceCategory.equipment;
      return r.category == ResourceCategory.room;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Resource Management',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Resource',
            onPressed: () => _showAddResourceDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'all', label: Text('All')),
                ButtonSegment(value: 'equipment', label: Text('Equipment')),
                ButtonSegment(value: 'rooms', label: Text('Rooms')),
              ],
              selected: {_selectedCategory},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedCategory = newSelection.first;
                });
              },
            ),
          ),
          // Resource List
          Expanded(
            child: _filteredResources.isEmpty
                ? EmptyStateCard(
                    title: 'No resources',
                    description: 'Add equipment or rooms to track their availability',
                    icon: Icons.construction_outlined,
                    actionLabel: 'Add Resource',
                    onAction: () => _showAddResourceDialog(),
                  )
                : ListView(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    children: [
                      ..._filteredResources.map((resource) => Padding(
                            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                            child: FrostedContainer(
                              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
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
                                            Row(
                                              children: [
                                                Icon(
                                                  resource.category == ResourceCategory.equipment
                                                      ? Icons.local_shipping
                                                      : Icons.room,
                                                  color: const Color(SwiftleadTokens.primaryTeal),
                                                  size: 20,
                                                ),
                                                const SizedBox(width: SwiftleadTokens.spaceS),
                                                Text(
                                                  resource.name,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: SwiftleadTokens.spaceXS),
                                            Text(
                                              resource.category == ResourceCategory.equipment
                                                  ? 'Equipment'
                                                  : 'Room',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      _buildStatusBadge(resource.status),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showEditResourceDialog(resource);
                                          } else if (value == 'delete') {
                                            _showDeleteConfirmDialog(resource);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Builder(
                                              builder: (context) => Row(
                                              children: [
                                                  const Icon(Icons.edit, size: 20),
                                                  const SizedBox(width: SwiftleadTokens.spaceS),
                                                  Text(
                                                    'Edit',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Builder(
                                              builder: (context) => Row(
                                              children: [
                                                  const Icon(Icons.delete, color: Color(SwiftleadTokens.errorRed), size: 20),
                                                  const SizedBox(width: SwiftleadTokens.spaceS),
                                                  Text(
                                                    'Delete',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(SwiftleadTokens.errorRed),
                                                    ),
                                                  ),
                                              ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (resource.status == ResourceStatus.inUse && resource.currentBookingName != null) ...[
                                    const SizedBox(height: SwiftleadTokens.spaceM),
                                    Container(
                                      padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                                      decoration: BoxDecoration(
                                        color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.event,
                                            size: 16,
                                            color: Color(SwiftleadTokens.warningYellow),
                                          ),
                                          const SizedBox(width: SwiftleadTokens.spaceS),
                                          Expanded(
                                            child: Text(
                                              'In use: ${resource.currentBookingName}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(SwiftleadTokens.warningYellow),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (resource.status == ResourceStatus.maintenance && resource.notes != null) ...[
                                    const SizedBox(height: SwiftleadTokens.spaceM),
                                    Container(
                                      padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                                      decoration: BoxDecoration(
                                        color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.build,
                                            size: 16,
                                            color: Color(SwiftleadTokens.errorRed),
                                          ),
                                          const SizedBox(width: SwiftleadTokens.spaceS),
                                          Expanded(
                                            child: Text(
                                              resource.notes!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(SwiftleadTokens.errorRed),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ResourceStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case ResourceStatus.available:
        color = const Color(SwiftleadTokens.successGreen);
        label = 'Available';
        icon = Icons.check_circle;
        break;
      case ResourceStatus.inUse:
        color = const Color(SwiftleadTokens.warningYellow);
        label = 'In Use';
        icon = Icons.event_busy;
        break;
      case ResourceStatus.maintenance:
        color = const Color(SwiftleadTokens.errorRed);
        label = 'Maintenance';
        icon = Icons.build;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddResourceDialog() {
    final nameController = TextEditingController();
    ResourceCategory? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Resource'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Resource Name',
                  hintText: 'e.g., Van 1, Room A',
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              SegmentedButton<ResourceCategory>(
                segments: [
                  ButtonSegment(
                    value: ResourceCategory.equipment,
                    label: const Text('Equipment'),
                    icon: const Icon(Icons.local_shipping),
                  ),
                  ButtonSegment(
                    value: ResourceCategory.room,
                    label: const Text('Room'),
                    icon: const Icon(Icons.room),
                  ),
                ],
                selected: selectedCategory != null ? {selectedCategory!} : {},
                onSelectionChanged: (Set<ResourceCategory> newSelection) {
                  setState(() {
                    selectedCategory = newSelection.first;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: 'Add',
              onPressed: () {
                if (nameController.text.isEmpty || selectedCategory == null) {
                  Toast.show(
                    context,
                    message: 'Please fill in all fields',
                    type: ToastType.error,
                  );
                  return;
                }
                final resource = Resource(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  category: selectedCategory!,
                  status: ResourceStatus.available,
                  currentBookingId: null,
                );
                setState(() {
                  _resources.add(resource);
                });
                Navigator.pop(context);
                Toast.show(
                  context,
                  message: 'Resource added',
                  type: ToastType.success,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditResourceDialog(Resource resource) {
    Toast.show(
      context,
      message: 'Edit resource functionality (mock)',
      type: ToastType.info,
    );
  }

  void _showDeleteConfirmDialog(Resource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resource'),
        content: Text('Are you sure you want to delete "${resource.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _resources.removeWhere((r) => r.id == resource.id);
              });
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Resource deleted',
                type: ToastType.success,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
          ),
        ],
      ),
    );
  }
}

enum ResourceCategory {
  equipment,
  room,
}

enum ResourceStatus {
  available,
  inUse,
  maintenance,
}

class Resource {
  final String id;
  final String name;
  final ResourceCategory category;
  final ResourceStatus status;
  final String? currentBookingId;
  final String? currentBookingName;
  final String? notes;

  Resource({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    this.currentBookingId,
    this.currentBookingName,
    this.notes,
  });
}


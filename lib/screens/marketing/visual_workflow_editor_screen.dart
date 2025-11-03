import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// Visual Workflow Editor Screen - Drag-drop canvas for multichannel campaigns
/// Exact specification from UI_Inventory_v2.5.1, line 551
class VisualWorkflowEditorScreen extends StatefulWidget {
  final String? campaignId;
  final Map<String, dynamic>? initialWorkflow;

  const VisualWorkflowEditorScreen({
    super.key,
    this.campaignId,
    this.initialWorkflow,
  });

  @override
  State<VisualWorkflowEditorScreen> createState() => _VisualWorkflowEditorScreenState();
}

class _VisualWorkflowEditorScreenState extends State<VisualWorkflowEditorScreen> {
  final List<_WorkflowNode> _nodes = [];
  final List<_WorkflowConnection> _connections = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadWorkflow();
  }

  void _loadWorkflow() {
    // Load initial workflow if editing
    if (widget.initialWorkflow != null) {
      // Parse workflow data
    }
    // Add default start node
    _nodes.add(_WorkflowNode(
      id: 'start',
      type: _NodeType.start,
      position: const Offset(100, 100),
      label: 'Start',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Workflow Editor',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveWorkflow,
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          _buildToolbar(),
          
          // Canvas
          Expanded(
            child: _buildCanvas(),
          ),
          
          // Node Palette
          _buildNodePalette(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return FrostedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {},
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {},
            tooltip: 'Zoom Out',
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          const VerticalDivider(),
          const SizedBox(width: SwiftleadTokens.spaceS),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {},
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {},
            tooltip: 'Redo',
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: _validateWorkflow,
            child: const Text('Validate'),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          PrimaryButton(
            label: 'Save',
            onPressed: _isSaving ? null : _saveWorkflow,
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Stack(
        children: [
          // Grid background
          CustomPaint(
            painter: _GridPainter(),
            size: Size.infinite,
          ),
          
          // Nodes
          ..._nodes.map((node) => _buildNode(node)),
          
          // Connections
          CustomPaint(
            painter: _ConnectionPainter(_connections),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }

  Widget _buildNode(_WorkflowNode node) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            node.position += details.delta;
          });
        },
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
          decoration: BoxDecoration(
            color: _getNodeColor(node.type),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getNodeIcon(node.type),
                size: 24,
              ),
              const SizedBox(height: SwiftleadTokens.spaceXS),
              Text(
                node.label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodePalette() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Node',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceS,
            children: _NodeType.values
                .where((type) => type != _NodeType.start)
                .map((type) => _buildPaletteItem(type))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteItem(_NodeType type) {
    return InkWell(
      onTap: () => _addNode(type),
      child: Container(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getNodeIcon(type),
              size: 20,
            ),
            const SizedBox(width: SwiftleadTokens.spaceXS),
            Text(_getNodeLabel(type)),
          ],
        ),
      ),
    );
  }

  void _addNode(_NodeType type) {
    setState(() {
      _nodes.add(_WorkflowNode(
        id: 'node_${_nodes.length}',
        type: type,
        position: Offset(
          200 + (_nodes.length * 150) % 400,
          200 + (_nodes.length * 100) % 300,
        ),
        label: _getNodeLabel(type),
      ));
    });
  }

  void _validateWorkflow() {
    // Validate workflow logic
    final errors = <String>[];
    
    if (_nodes.isEmpty) {
      errors.add('Workflow must have at least one node');
    }
    
    if (!_nodes.any((node) => node.type == _NodeType.start)) {
      errors.add('Workflow must have a start node');
    }
    
    if (errors.isEmpty) {
      Toast.show(
        context,
        message: 'Workflow is valid',
        type: ToastType.success,
      );
    } else {
      Toast.show(
        context,
        message: errors.join(', '),
        type: ToastType.error,
      );
    }
  }

  Future<void> _saveWorkflow() async {
    setState(() => _isSaving = true);
    
    // Simulate save
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isSaving = false);
      Toast.show(
        context,
        message: 'Workflow saved successfully',
        type: ToastType.success,
      );
      Navigator.of(context).pop(true);
    }
  }

  Color _getNodeColor(_NodeType type) {
    switch (type) {
      case _NodeType.start:
        return const Color(SwiftleadTokens.successGreen);
      case _NodeType.email:
        return const Color(SwiftleadTokens.infoBlue);
      case _NodeType.sms:
        return const Color(SwiftleadTokens.warningYellow);
      case _NodeType.wait:
        return const Color(SwiftleadTokens.primaryTeal);
      case _NodeType.condition:
        return const Color(SwiftleadTokens.errorRed);
      case _NodeType.end:
        return Colors.grey;
    }
  }

  IconData _getNodeIcon(_NodeType type) {
    switch (type) {
      case _NodeType.start:
        return Icons.play_arrow;
      case _NodeType.email:
        return Icons.email;
      case _NodeType.sms:
        return Icons.sms;
      case _NodeType.wait:
        return Icons.schedule;
      case _NodeType.condition:
        return Icons.code;
      case _NodeType.end:
        return Icons.stop;
    }
  }

  String _getNodeLabel(_NodeType type) {
    switch (type) {
      case _NodeType.start:
        return 'Start';
      case _NodeType.email:
        return 'Send Email';
      case _NodeType.sms:
        return 'Send SMS';
      case _NodeType.wait:
        return 'Wait';
      case _NodeType.condition:
        return 'Condition';
      case _NodeType.end:
        return 'End';
    }
  }
}

class _WorkflowNode {
  final String id;
  final _NodeType type;
  Offset position;
  final String label;

  _WorkflowNode({
    required this.id,
    required this.type,
    required this.position,
    required this.label,
  });
}

class _WorkflowConnection {
  final String fromNodeId;
  final String toNodeId;

  _WorkflowConnection({
    required this.fromNodeId,
    required this.toNodeId,
  });
}

enum _NodeType {
  start,
  email,
  sms,
  wait,
  condition,
  end,
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    const gridSize = 20.0;
    
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConnectionPainter extends CustomPainter {
  final List<_WorkflowConnection> connections;

  _ConnectionPainter(this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(SwiftleadTokens.primaryTeal)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connections between nodes
    for (final connection in connections) {
      // Simplified connection drawing
      // In a real implementation, this would connect actual node positions
      canvas.drawLine(
        const Offset(0, 0),
        const Offset(100, 100),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


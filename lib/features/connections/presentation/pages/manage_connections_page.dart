import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/connection_model.dart';

class ManageConnectionsPage extends StatefulWidget {
  const ManageConnectionsPage({super.key});

  @override
  State<ManageConnectionsPage> createState() => _ManageConnectionsPageState();
}

class _ManageConnectionsPageState extends State<ManageConnectionsPage> {
  late List<ConnectionModel> _connections;

  @override
  void initState() {
    super.initState();
    _connections = List.from(MockData.connections);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Manage Connections', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.addConnection),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: _connections.length + 1,
        itemBuilder: (context, index) {
          if (index == _connections.length) {
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: AppButton(
                label: 'Add New Connection',
                onPressed: () => context.push(AppRoutes.addConnection),
                variant: AppButtonVariant.outline,
                icon: Icons.add_rounded,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 80));
          }

          final conn = _connections[index];
          return _ConnectionTile(
            connection: conn,
            animDelay: Duration(milliseconds: index * 80),
            onRemove: () => _removeConnection(index),
            onSwitch: () => _switchConnection(index),
          );
        },
      ),
    );
  }

  void _switchConnection(int index) {
    setState(() {
      for (int i = 0; i < _connections.length; i++) {
        _connections[i] = ConnectionModel(
          id: _connections[i].id,
          accountNumber: _connections[i].accountNumber,
          name: _connections[i].name,
          type: _connections[i].type,
          isActive: i == index,
          planName: _connections[i].planName,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${_connections[index].name}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _removeConnection(int index) {
    if (_connections[index].isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot remove the active connection')),
      );
      return;
    }
    final removed = _connections[index];
    setState(() => _connections.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _connections.insert(index, removed)),
        ),
      ),
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  const _ConnectionTile({
    required this.connection,
    required this.animDelay,
    required this.onRemove,
    required this.onSwitch,
  });

  final ConnectionModel connection;
  final Duration animDelay;
  final VoidCallback onRemove;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final t = connection.type;

    return Dismissible(
      key: ValueKey(connection.id),
      direction: connection.isActive ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: connection.isActive ? AppColors.primary : AppColors.borderLight,
            width: connection.isActive ? 2 : 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: t.color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(t.icon, color: t.color, size: 22),
          ),
          title: Row(
            children: [
              Text(connection.name, style: AppTextStyles.titleSmall),
              if (connection.isActive) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Active', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(connection.accountNumber, style: AppTextStyles.bodySmall),
              Text(connection.planName, style: AppTextStyles.caption),
            ],
          ),
          trailing: !connection.isActive
              ? TextButton(
                  onPressed: onSwitch,
                  child: const Text('Switch'),
                )
              : null,
        ),
      ),
    ).animate(delay: animDelay).fadeIn(duration: 300.ms).slideX(begin: -0.1);
  }
}

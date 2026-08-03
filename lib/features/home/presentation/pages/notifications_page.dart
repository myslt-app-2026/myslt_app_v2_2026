import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<NotificationModel> _notifs;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _notifs = List.from(MockData.notifications);
  }
}
void _markAllRead() {
    setState(() {
      _notifs = _notifs.map((n) => n.copyWith(isRead: true)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _dismissNotification(int index, NotificationModel item) {
    setState(() {
      _notifs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification dismissed'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _notifs.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  List<NotificationModel> get _filteredNotifs {
    if (_selectedCategory == 'All') return _notifs;
    return _notifs.where((n) {
      if (_selectedCategory == 'Bill') return n.type == NotificationType.bill;
      if (_selectedCategory == 'Usage') return n.type == NotificationType.usage;
      if (_selectedCategory == 'Promo') return n.type == NotificationType.promo;
      return true;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Notifications', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_notifs.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.md),
            child: Row(
              children: ['All', 'Bill', 'Usage', 'Promo'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withAlpha(40),
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Placeholder for list
          Expanded(child: Container()),
        ],
      ),
    );
  }
  

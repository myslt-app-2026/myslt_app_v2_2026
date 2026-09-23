import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/notification_model.dart';
import '../../providers/home_provider.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  late List<NotificationModel> _notifs;
  String _selectedCategory = 'All';
  bool _isSendingPush = false;

  @override
  void initState() {
    super.initState();
    _notifs = List.from(MockData.notifications);
  }

  Future<void> _handleSendPushNotification() async {
    setState(() => _isSendingPush = true);
    final repo = ref.read(bannerNotificationRepositoryProvider);
    final res = await repo.postPushNotification(
      accountNo: '0312241780',
      notType: 'BILL_ALERT',
      email: 'user@slt.lk',
      mobile: '0771234567',
    );

    if (!mounted) return;
    setState(() {
      _isSendingPush = false;
      if (res.isSuccess) {
        final newNotif = NotificationModel(
          id: res.messageId ?? 'PUSH-${DateTime.now().millisecondsSinceEpoch}',
          title: 'SMS & Push Alert Dispatched',
          body: 'Your live account status and bill reminder have been synced with SLT network.',
          timestamp: DateTime.now(),
          type: NotificationType.bill,
          isRead: false,
        );
        _notifs.insert(0, newNotif);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.isSuccess
            ? 'Push notification dispatched! (ID: ${res.messageId ?? 'Delivered'})'
            : (res.errorMessage ?? 'Failed to send push notification')),
        backgroundColor: res.isSuccess ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          IconButton(
            tooltip: 'Send Push Notification',
            icon: _isSendingPush
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_to_mobile_rounded, color: AppColors.primary),
            onPressed: _isSendingPush ? null : _handleSendPushNotification,
          ),
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
          
          // Notification list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textTertiary),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No notifications found',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.delete_rounded, color: Colors.white),
                        ),
                        onDismissed: (_) => _dismissNotification(index, item),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: item.isRead ? Colors.white : AppColors.primary.withAlpha(10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: item.isRead ? AppColors.borderLight : AppColors.primary.withAlpha(51),
                              width: item.isRead ? 1 : 1.5,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: item.type.color.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.type.icon, color: item.type.color, size: 20),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (!item.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(item.body, style: AppTextStyles.bodySmall),
                                const SizedBox(height: 6),
                                Text(_formatTime(item.timestamp), style: AppTextStyles.caption),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                final notifIndex = _notifs.indexWhere((n) => n.id == item.id);
                                if (notifIndex != -1) {
                                  _notifs[notifIndex] = _notifs[notifIndex].copyWith(isRead: true);
                                }
                              });
                            },
                          ),
                        ),
                      ).animate().fadeIn(duration: 200.ms, delay: Duration(milliseconds: index * 40));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${time.day}/${time.month}';
  }
}
        
          
  

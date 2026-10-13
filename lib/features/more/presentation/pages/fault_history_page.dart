import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../data/repositories/fault_repository.dart';

class FaultHistoryPage extends StatefulWidget {
  const FaultHistoryPage({super.key});

  @override
  State<FaultHistoryPage> createState() => _FaultHistoryPageState();
}

class _FaultHistoryPageState extends State<FaultHistoryPage> {
  final _faultRepository = FaultRepository();
  final _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> _allTickets = [];
  List<Map<String, dynamic>> _filteredTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);
    final tickets = await _faultRepository.getFaultHistoryDashboard();
    if (!mounted) return;
    setState(() {
      _allTickets = tickets;
      _filteredTickets = tickets;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredTickets = _allTickets;
      } else {
        _filteredTickets = _allTickets.where((t) {
          final id = (t['ticketId'] ?? '').toString().toLowerCase();
          final title = (t['title'] ?? '').toString().toLowerCase();
          final cat = (t['category'] ?? '').toString().toLowerCase();
          return id.contains(query) || title.contains(query) || cat.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inProgressCount =
        _allTickets.where((t) => t['status'] == 'In Progress').length;
    final resolvedCount =
        _allTickets.where((t) => t['status'] == 'Resolved' || t['status'] == 'Closed').length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Fault History Dashboard', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: _loadDashboard,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadDashboard,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Stat Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'Total Tickets',
                            value: '${_allTickets.length}',
                            icon: Icons.receipt_long_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildStatCard(
                            label: 'In Progress',
                            value: '$inProgressCount',
                            icon: Icons.pending_actions_rounded,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildStatCard(
                            label: 'Resolved',
                            value: '$resolvedCount',
                            icon: Icons.check_circle_rounded,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: AppSpacing.lg),

                    // Quick Track Search Bar
                    Text('Track & Search Tickets', style: AppTextStyles.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter Ticket ID (e.g. TT10294) or keyword',
                        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                onPressed: () => _searchCtrl.clear(),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 50.ms),
                    const SizedBox(height: AppSpacing.lg),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Complaints', style: AppTextStyles.titleSmall),
                        TextButton.icon(
                          onPressed: () => context.push(AppRoutes.reportFault),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('New Fault'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    if (_filteredTickets.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.task_alt_rounded, size: 48, color: AppColors.textTertiary),
                            const SizedBox(height: AppSpacing.md),
                            Text('No fault tickets found', style: AppTextStyles.titleSmall),
                            const SizedBox(height: 4),
                            Text('You have no registered complaint records matching your query.',
                                style: AppTextStyles.caption, textAlign: TextAlign.center),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredTickets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final ticket = _filteredTickets[index];
                          return _buildTicketCard(ticket);
                        },
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final ticketId = ticket['ticketId'] ?? 'TT10294';
    final title = ticket['title'] ?? 'Complaint';
    final category = ticket['category'] ?? 'Broadband';
    final status = ticket['status'] ?? 'In Progress';
    final date = ticket['createdDate'] ?? '';

    Color statusColor;
    Color statusBg;

    if (status == 'In Progress') {
      statusColor = AppColors.warning;
      statusBg = AppColors.warningLight;
    } else if (status == 'Resolved') {
      statusColor = AppColors.success;
      statusBg = AppColors.successLight;
    } else {
      statusColor = AppColors.textSecondary;
      statusBg = AppColors.backgroundLight;
    }

    return InkWell(
      onTap: () => context.push('/track-ticket?ticketId=$ticketId'),
      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticketId,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: AppTextStyles.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(category, style: AppTextStyles.caption),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(date, style: AppTextStyles.caption),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

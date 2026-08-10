import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/bill_model.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text(
              'Bill & Payments',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.download_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: Column(
                      children: [
                        AppShimmer.card(height: 220),
                        const SizedBox(height: AppSpacing.lg),
                        AppShimmer.listItem(count: 4),
                      ],
                    ),
                  )
                : _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bill = MockData.currentBill;
    final history = MockData.billHistory;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Bill Card
          _CurrentBillCard(bill: bill)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, curve: Curves.easeOut),
          const SizedBox(height: AppSpacing.xl),

          Text('Bill History', style: AppTextStyles.titleMedium)
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms),
          const SizedBox(height: AppSpacing.md),

          ...history.asMap().entries.map((e) {
            return _BillHistoryTile(bill: e.value)
                .animate()
                .fadeIn(duration: 300.ms, delay: Duration(milliseconds: 150 + e.key * 80))
                .slideX(begin: -0.1, curve: Curves.easeOut);
          }),
          const SizedBox(height: AppSpacing.xl4),
        ],
      ),
    );
  }
}

class _CurrentBillCard extends StatelessWidget {
  const _CurrentBillCard({required this.bill});

  final BillModel bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.cardGradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Bill',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bill.status.color.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: bill.status.color.withAlpha(128),
                    width: 1,
                  ),
                ),
                child: Text(
                  bill.status.label,
                  style: AppTextStyles.caption.copyWith(
                    color: bill.status.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppFormatters.formatLKR(bill.amount),
            style: AppTextStyles.amountLarge.copyWith(color: Colors.white),
          ),
          Text(
            bill.period,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withAlpha(153),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14, color: Colors.white.withAlpha(179)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppFormatters.formatDueDateCountdown(bill.dueDate),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withAlpha(179),
                ),
              ),
              const Spacer(),
              Text(
                AppFormatters.formatDate(bill.dueDate),
                style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.billPayment),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              elevation: 0,
            ),
            child: Text(
              'Pay Now  →',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillHistoryTile extends StatelessWidget {
  const _BillHistoryTile({required this.bill});

  final BillModel bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.dividerLight, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bill.status.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: bill.status.color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.period, style: AppTextStyles.titleSmall),
                Text(
                  bill.paidDate != null
                      ? 'Paid on ${AppFormatters.formatDate(bill.paidDate!)}'
                      : 'Issued ${AppFormatters.formatDate(bill.issueDate)}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.formatLKR(bill.amount),
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: bill.status.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bill.status.label,
                  style: AppTextStyles.caption.copyWith(
                    color: bill.status.color,
                    fontWeight: FontWeight.w600,
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

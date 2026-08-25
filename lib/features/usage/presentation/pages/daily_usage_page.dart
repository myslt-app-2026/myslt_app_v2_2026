import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/usage_model.dart';
import '../../providers/usage_provider.dart';

class DailyUsagePage extends ConsumerStatefulWidget {
  const DailyUsagePage({super.key});

  @override
  ConsumerState<DailyUsagePage> createState() => _DailyUsagePageState();
}

class _DailyUsagePageState extends ConsumerState<DailyUsagePage> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedUsageDateProvider);
    final usageAsync = ref.watch(dailyUsageProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text(
              'Data Usage',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.assessment_outlined, color: Colors.white),
                onPressed: () => context.push(AppRoutes.usageReport),
                tooltip: 'Detailed Report',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: usageAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(children: [
                  AppShimmer.card(height: 60),
                  const SizedBox(height: AppSpacing.lg),
                  AppShimmer.card(height: 240),
                  const SizedBox(height: AppSpacing.lg),
                  AppShimmer.card(height: 160),
                ]),
              ),
              data: (usage) {
                final totalUsed = usage.fold(0.0, (s, u) => s + u.usedMB);
                return _buildContent(context, usage, totalUsed, selectedDate);
              },
              error: (_, __) {
                final usage = MockData.todayHourlyUsage;
                final totalUsed = usage.fold(0.0, (s, u) => s + u.usedMB);
                return _buildContent(context, usage, totalUsed, selectedDate);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<HourlyUsageModel> usage,
    double total,
    DateTime selectedDate,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          _DateSelector(
            selected: selectedDate,
            onChanged: (d) =>
                ref.read(dailyUsageProvider.notifier).fetchForDate(d),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.xl),

          // Summary row
          Row(
            children: [
              _UsageStat(
                label: 'Total Used',
                value: AppFormatters.formatDataSizeCompact(total),
                color: AppColors.primary,
              ),
              _UsageStat(
                label: 'Peak Hour',
                value: '8 PM - 9 PM',
                color: AppColors.teal,
              ),
              _UsageStat(
                label: 'Avg/Hour',
                value: AppFormatters.formatDataSizeCompact(total > 0 ? total / 24 : 0),
                color: AppColors.warning,
              ),
            ],
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
          const SizedBox(height: AppSpacing.xl),

          // Bar chart
          Text('Hourly Breakdown', style: AppTextStyles.titleMedium)
              .animate()
              .fadeIn(duration: 300.ms, delay: 150.ms),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 220,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1200,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        AppFormatters.formatDataSizeCompact(rod.toY),
                        AppTextStyles.caption.copyWith(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        if (hour % 4 != 0) return const SizedBox.shrink();
                        return Text(
                          hour == 0 ? '12A' : (hour < 12 ? '${hour}A' : (hour == 12 ? '12P' : '${hour - 12}P')),
                          style: AppTextStyles.caption,
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          AppFormatters.formatDataSizeCompact(value),
                          style: AppTextStyles.caption,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.dividerLight,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: usage.map((u) {
                  return BarChartGroupData(
                    x: u.hour,
                    barRods: [
                      BarChartRodData(
                        toY: u.usedMB,
                        gradient: LinearGradient(
                          colors: [AppColors.teal, AppColors.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 7,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: AppSpacing.xl),

          // Category breakdown
          Text('By Category', style: AppTextStyles.titleMedium)
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms),
          const SizedBox(height: AppSpacing.md),
          _CategoryBreakdown(total: total)
              .animate()
              .fadeIn(duration: 400.ms, delay: 350.ms),
          const SizedBox(height: AppSpacing.xl4),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.selected, required this.onChanged});

  final DateTime selected;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Text(
            AppFormatters.formatDate(selected),
            style: AppTextStyles.titleSmall,
          ),
          const Spacer(),
          TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selected,
                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                lastDate: DateTime.now(),
                builder: (ctx, child) {
                  return Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) onChanged(date);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _UsageStat extends StatelessWidget {
  const _UsageStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withAlpha(13),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.labelLarge.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.total});

  final double total;

  static const _categories = [
    ('Streaming', 0.45, AppColors.primary),
    ('Browsing', 0.25, AppColors.teal),
    ('Social Media', 0.20, Color(0xFF7C3AED)),
    ('Gaming', 0.07, AppColors.warning),
    ('Other', 0.03, AppColors.textTertiary),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _categories.map((cat) {
        final (label, pct, color) = cat;
        final mb = total * pct;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label, style: AppTextStyles.bodySmall),
                        Text(
                          AppFormatters.formatDataSizeCompact(mb),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

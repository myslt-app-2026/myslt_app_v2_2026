import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/utils/formatters.dart';

class DetailedReportPage extends StatelessWidget {
  const DetailedReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final daily = MockData.monthlyUsage;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Detailed Report', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {},
            tooltip: 'Export',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Monthly summary card
                  _MonthlySummaryCard(daily: daily)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2),
                  const SizedBox(height: AppSpacing.xl),

                  // Line chart
                  Text('30-Day Trend', style: AppTextStyles.titleMedium)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms),
                  const SizedBox(height: AppSpacing.md),
                  _TrendChart(daily: daily)
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 150.ms),
                  const SizedBox(height: AppSpacing.xl),

                  // Daily accordion
                  Text('Daily Breakdown', style: AppTextStyles.titleMedium)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: daily.length > 7 ? 7 : daily.length,
            itemBuilder: (context, index) {
              final day = daily[daily.length - 1 - index];
              return _DayTile(day: day, index: index);
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl4)),
        ],
      ),
    );
  }
}

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({required this.daily});

  final List<dynamic> daily;

  @override
  Widget build(BuildContext context) {
    final total = daily.fold(0.0, (s, d) => s + (d.usedMB as double));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBox(
            label: 'Total Used',
            value: AppFormatters.formatDataSizeCompact(total),
          ),
          _StatBox(
            label: 'Daily Avg',
            value: AppFormatters.formatDataSizeCompact(total / daily.length),
          ),
          _StatBox(
            label: 'Period',
            value: AppFormatters.formatMonth(DateTime.now()),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withAlpha(179),
          ),
        ),
      ],
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.daily});

  final List<dynamic> daily;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.dividerLight,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= daily.length) return const SizedBox.shrink();
                  return Text(
                    AppFormatters.formatDate((daily[idx]).date).substring(0, 5),
                    style: AppTextStyles.caption,
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (v, _) => Text(
                  AppFormatters.formatDataSizeCompact(v),
                  style: AppTextStyles.caption,
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: daily.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.usedMB as double);
              }).toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.teal],
              ),
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withAlpha(51),
                    AppColors.teal.withAlpha(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.day, required this.index});

  final dynamic day;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        title: Row(
          children: [
            Text(
              AppFormatters.formatDate(day.date),
              style: AppTextStyles.titleSmall,
            ),
            const Spacer(),
            Text(
              AppFormatters.formatDataSizeCompact(day.usedMB),
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        children: [
          _CategoryRow('Streaming', day.streamingMB, AppColors.primary),
          _CategoryRow('Browsing', day.browsingMB, AppColors.teal),
          _CategoryRow('Social', day.socialMB, const Color(0xFF7C3AED)),
          _CategoryRow('Gaming', day.gamingMB, AppColors.warning),
        ],
      ),
    ).animate().fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: index * 50),
        );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.label, this.mb, this.color);

  final String label;
  final double mb;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
          Text(
            AppFormatters.formatDataSizeCompact(mb),
            style: AppTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }
}

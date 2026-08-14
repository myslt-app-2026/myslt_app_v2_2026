import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/loyalty_model.dart';

class LoyaltyPointsPage extends StatelessWidget {
  const LoyaltyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loyalty = MockData.loyaltyPoints;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: const Color(0xFFD97706),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFFBBF24)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(30), width: 2),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: 60,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(15), width: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(loyalty.tier.icon, color: Colors.white, size: 32),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Loyalty Points',
                                      style: AppTextStyles.headlineMedium
                                          .copyWith(color: Colors.white)),
                                  Text('${loyalty.tier.label} Member',
                                      style: AppTextStyles.bodySmall
                                          .copyWith(color: Colors.white70)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // Points counter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${loyalty.totalPoints}',
                                    style: AppTextStyles.amountLarge
                                        .copyWith(color: Colors.white),
                                  ),
                                  Text('Total Points',
                                      style: AppTextStyles.caption
                                          .copyWith(color: Colors.white70)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white.withAlpha(60)),
                                ),
                                child: Text(
                                  '${loyalty.redeemablePoints} redeemable',
                                  style: AppTextStyles.labelMedium
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tier Progress
                  _TierProgressCard(loyalty: loyalty)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.lg),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.redeem_rounded,
                          label: 'Redeem\nData',
                          color: const Color(0xFF059669),
                          onTap: () => context.push(AppRoutes.redeemData),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.card_giftcard_rounded,
                          label: 'Gift\nData',
                          color: const Color(0xFF7C3AED),
                          onTap: () => context.push(AppRoutes.giftData),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Data\nLoan',
                          color: const Color(0xFF0066CC),
                          onTap: () => context.push(AppRoutes.dataLoan),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xl),

                  // How to Earn
                  _HowToEarnCard()
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xl),

                  // History
                  Text('Points History',
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  ...loyalty.history.asMap().entries.map((entry) {
                    return _HistoryTile(
                      entry: entry.value,
                      animDelay: Duration(milliseconds: 350 + entry.key * 60),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierProgressCard extends StatelessWidget {
  const _TierProgressCard({required this.loyalty});
  final LoyaltyPointsModel loyalty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tier Progress',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.textSecondary)),
              Text(
                '${loyalty.totalPoints} / ${loyalty.nextTierPoints}',
                style: AppTextStyles.labelMedium.copyWith(color: loyalty.tier.color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: loyalty.tierProgress,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(loyalty.tier.color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${loyalty.nextTierPoints - loyalty.totalPoints} points to ${_nextTierLabel(loyalty.tier)}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  String _nextTierLabel(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.bronze:
        return 'Silver';
      case LoyaltyTier.silver:
        return 'Gold';
      case LoyaltyTier.gold:
        return 'Platinum';
      case LoyaltyTier.platinum:
        return 'Max Tier';
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(label,
                style: AppTextStyles.caption.copyWith(
                    color: color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _HowToEarnCard extends StatelessWidget {
  static const _ways = [
    ('Pay your bill on time', Icons.receipt_long_rounded, '+10 pts/Rs.100'),
    ('Purchase data packages', Icons.widgets_rounded, '+50 pts/package'),
    ('Refer a friend', Icons.people_rounded, '+500 pts'),
    ('Stay on auto-pay', Icons.autorenew_rounded, '+200 pts/month'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('How to Earn Points',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: const Color(0xFFD97706))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ..._ways.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(w.$2, size: 16, color: const Color(0xFFD97706)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: Text(w.$1, style: AppTextStyles.bodySmall)),
                    Text(w.$3,
                        style: AppTextStyles.caption
                            .copyWith(color: const Color(0xFFD97706), fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry, required this.animDelay});

  final LoyaltyHistoryEntry entry;
  final Duration animDelay;

  @override
  Widget build(BuildContext context) {
    final isPositive = entry.isEarned;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successLight
                  : AppColors.errorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPositive ? Icons.add_rounded : Icons.remove_rounded,
              color: isPositive ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(_formatDate(entry.date), style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${entry.points}',
            style: AppTextStyles.titleSmall.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate(delay: animDelay).fadeIn(duration: 250.ms).slideX(begin: -0.05);
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/account_summary_model.dart';
import '../../data/models/popup_banner_model.dart';
import '../../data/models/promotion_model.dart';
import '../../providers/home_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../widgets/account_summary_card.dart';
import '../widgets/promotion_carousel.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/service_section.dart';

import '../../../usage/providers/usage_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _popupChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPopupBanner());
  }

  Future<void> _checkPopupBanner() async {
    if (_popupChecked || !mounted) return;
    _popupChecked = true;
    try {
      final popups = await ref.read(popupBannersProvider.future);
      if (!mounted || popups.isEmpty) return;
      final active = popups.firstWhere((p) => p.isActive, orElse: () => popups.first);
      if (active.isActive) {
        _showPopupDialog(active);
      }
    } catch (_) {}
  }

  void _showPopupDialog(PopupBannerModel popup) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.cardGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        popup.popupType,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(ctx).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      popup.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      popup.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Offer activated: ${popup.title}'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                        ),
                      ),
                      child: Text(popup.buttonTitle.isNotEmpty ? popup.buttonTitle : 'Explore Offer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(homeProvider);
    ref.invalidate(promotionsProvider);
    ref.invalidate(popupBannersProvider);
    ref.invalidate(profileProvider);
    ref.invalidate(currentBroadbandUsageProvider);
    ref.invalidate(dailyUsageProvider);
    ref.invalidate(monthlyUsageProvider);
    ref.invalidate(freeDataProvider);
    ref.invalidate(bonusDataProvider);
    ref.invalidate(myPackageProvider);
    await ref.read(homeProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(homeProvider);
    final promotionsAsync = ref.watch(promotionsProvider);
    final profileAsync = ref.watch(profileProvider);
    final greeting = AppFormatters.greeting();
    // Prefer real name from GetUserInfo (Endpoint 7); fall back to auth state or placeholder
    final userName = profileAsync.valueOrNull?.name.split(' ').first
        ?? ref.read(authNotifierProvider).user
        ?? 'Kasun';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        displacement: 80,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── App Bar ─────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 145,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primaryDark,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderBg(
                  greeting,
                  userName,
                  summaryAsync.valueOrNull?.accountNumber ?? '011XXXXXXX',
                ),
                collapseMode: CollapseMode.pin,
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(35),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => context.push(AppRoutes.notifications),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 14),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(35),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.grid_view_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => context.push(AppRoutes.more),
                  ),
                ),
              ],
            ),

            // ── Content ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: summaryAsync.when(
                data: (summary) => _buildContent(
                  context,
                  summary,
                  promotionsAsync.valueOrNull ?? MockData.promotions,
                ),
                loading: () => AppShimmer.dashboard(),
                error: (_, __) => _buildContent(
                  context,
                  MockData.accountSummary,
                  MockData.promotions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBg(String greeting, String userName, String accountNumber) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E676),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00E676),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          accountNumber,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildServiceSubNav(),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSubNav() {
    final items = [
      (Icons.wifi_rounded, 'Internet'),
      (Icons.tv_rounded, 'PEO TV'),
      (Icons.phone_rounded, 'Voice'),
      (Icons.phone_android_rounded, 'Mobile'),
      (Icons.local_offer_rounded, 'Promo'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.$1, color: Colors.white.withAlpha(220), size: 14),
            const SizedBox(width: 4),
            Text(
              item.$2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AccountSummaryModel summary,
    List<PromotionModel> promotions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Account Summary Card ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.lg,
            AppSpacing.pagePadding,
            0,
          ),
          child: AccountSummaryCard(summary: summary),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, curve: Curves.easeOut),

        const SizedBox(height: AppSpacing.xl),

        // ── Quick Actions ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick Actions', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.md),
              QuickActionGrid(),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.2),

        const SizedBox(height: AppSpacing.xl),

        // ── Promotions Carousel ───────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Promotions', style: AppTextStyles.titleMedium),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PromotionCarousel(promotions: promotions),
          ],
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

        const SizedBox(height: AppSpacing.xl),

        // ── Services ──────────────────────────────────────────────────
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: ServiceSection(),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

        const SizedBox(height: AppSpacing.xl4),
      ],
    );
  }
}

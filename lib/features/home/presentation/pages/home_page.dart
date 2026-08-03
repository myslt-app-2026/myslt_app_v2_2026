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
import '../widgets/account_summary_card.dart';
import '../widgets/promotion_carousel.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/service_section.dart';

final _homeLoadingProvider = StateProvider<bool>((ref) => true);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      ref.read(_homeLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _handleRefresh() async {
    ref.read(_homeLoadingProvider.notifier).state = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      ref.read(_homeLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_homeLoadingProvider);
    final authState = ref.watch(authNotifierProvider);
    final greeting = AppFormatters.greeting();
    final userName = authState.user ?? 'Kasun';

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
              expandedHeight: 160,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderBg(greeting, userName),
                collapseMode: CollapseMode.pin,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
                IconButton(
                  icon: Icon(Icons.person_outline_rounded,
                      color: Colors.white),
                  onPressed: () => context.push(AppRoutes.profile),
                ),
                const SizedBox(width: 4),
              ],
            ),

            // ── Content ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: isLoading
                  ? AppShimmer.dashboard()
                  : _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBg(String greeting, String userName) {
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
            top: -20,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(20),
                  width: 2,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.md,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$greeting, 👋',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                  Text(
                    userName,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      MockData.accountSummary.accountNumber,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final summary = MockData.accountSummary;
    final promotions = MockData.promotions;

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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../packages/presentation/pages/fiber_page.dart';
import '../../../peotv/presentation/widgets/peotv_go_dialog.dart';

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.badge,
    this.route,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String? badge;
  final String? route;
  final void Function(BuildContext context, WidgetRef ref)? onTap;
}

/// Services Page displaying the full suite of SLT-Mobitel digital, broadband,
/// TV, voice, and value-added services.
class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  static const List<String> _categories = [
    'All',
    'Broadband',
    'TV',
    'Mobile',
    'Voice',
    'VAS',
    'Support',
  ];

  static const List<_ServiceItem> _allServices = [
    _ServiceItem(
      title: 'Fiber Broadband',
      subtitle: 'Ultra-fast FTTH up to 1 Gbps & unlimited night data',
      category: 'Broadband',
      icon: Icons.router_rounded,
      color: Color(0xFF0066CC),
      bgColor: Color(0xFFE0EEFF),
      badge: 'High Speed',
      onTap: _openFiberPage,
    ),
    _ServiceItem(
      title: 'New Connection',
      subtitle: 'Apply online for Fibre, PEO TV or Fixed Voice',
      category: 'Broadband',
      icon: Icons.add_link_rounded,
      color: Color(0xFF0284C7),
      bgColor: Color(0xFFE0F2FE),
      badge: 'Online KYC',
      route: AppRoutes.newConnection,
    ),
    _ServiceItem(
      title: 'PEO TV',
      subtitle: '200+ Live Channels, Rewind TV, HD Movies & Series',
      category: 'TV',
      icon: Icons.tv_rounded,
      color: Color(0xFF7C3AED),
      bgColor: Color(0xFFF3EEFF),
      badge: 'HD Channels',
      route: AppRoutes.peotv,
    ),
    _ServiceItem(
      title: 'PEO TV GO',
      subtitle: 'Live TV & streaming access pass on your phone & web',
      category: 'TV',
      icon: Icons.play_circle_fill_rounded,
      color: Color(0xFF9333EA),
      bgColor: Color(0xFFFAF5FF),
      badge: 'Streaming',
      onTap: _openPeoTvGo,
    ),
    _ServiceItem(
      title: 'Mobitel 4G / 5G',
      subtitle: 'Prepaid, Postpaid, eSIM, Unlimited Social & Roaming',
      category: 'Mobile',
      icon: Icons.signal_cellular_alt_rounded,
      color: Color(0xFF0D9488),
      bgColor: Color(0xFFCCFBF1),
      badge: 'Nationwide',
      onTap: _showMobitelInfo,
    ),
    _ServiceItem(
      title: 'Fixed Voice',
      subtitle: 'Crystal-clear home & enterprise landline telephone lines',
      category: 'Voice',
      icon: Icons.phone_in_talk_rounded,
      color: Color(0xFF059669),
      bgColor: Color(0xFFD1FAE5),
      badge: 'Fixed Line',
      onTap: _showVoiceInfo,
    ),
    _ServiceItem(
      title: 'IDD Services',
      subtitle: 'Affordable international calling rates & custom budget packs',
      category: 'Voice',
      icon: Icons.public_rounded,
      color: Color(0xFF4B5563),
      bgColor: Color(0xFFF3F4F6),
      badge: 'Worldwide',
      route: AppRoutes.iddServices,
    ),
    _ServiceItem(
      title: 'Gift Data',
      subtitle: 'Instantly transfer or gift data to any SLT broadband user',
      category: 'VAS',
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFFE11D48),
      bgColor: Color(0xFFFFE4E6),
      badge: 'Data Share',
      route: AppRoutes.giftData,
    ),
    _ServiceItem(
      title: 'Data Loan',
      subtitle: 'Get an instant data advance when you run out of data',
      category: 'VAS',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF2563EB),
      bgColor: Color(0xFFDBEAFE),
      badge: 'Emergency',
      route: AppRoutes.dataLoan,
    ),
    _ServiceItem(
      title: 'Redeem Points',
      subtitle: 'Convert SLT Rewards loyalty points to free GBs & bill credits',
      category: 'VAS',
      icon: Icons.stars_rounded,
      color: Color(0xFFD97706),
      bgColor: Color(0xFFFEF3C7),
      badge: 'Loyalty',
      route: AppRoutes.redeemData,
    ),
    _ServiceItem(
      title: 'Happy Day',
      subtitle: 'Enjoy unlimited high-speed data on your chosen special day',
      category: 'VAS',
      icon: Icons.sentiment_very_satisfied_rounded,
      color: Color(0xFFEA580C),
      bgColor: Color(0xFFFFEDD5),
      badge: 'Free Data',
      route: AppRoutes.happyDay,
    ),
    _ServiceItem(
      title: 'Teleshop Locator',
      subtitle: 'Find the nearest SLT-Mobitel branches, counters and kiosks',
      category: 'Support',
      icon: Icons.location_on_rounded,
      color: Color(0xFF10B981),
      bgColor: Color(0xFFD1FAE5),
      badge: 'Near You',
      route: AppRoutes.locationServices,
    ),
    _ServiceItem(
      title: 'Report Fault',
      subtitle: 'Lodge technical complaints and track fault clearing status',
      category: 'Support',
      icon: Icons.report_problem_outlined,
      color: Color(0xFFDC2626),
      bgColor: Color(0xFFFEE2E2),
      badge: '24/7 Care',
      route: AppRoutes.reportFault,
    ),
    _ServiceItem(
      title: 'Track Ticket',
      subtitle: 'Check real-time status of your support or service requests',
      category: 'Support',
      icon: Icons.track_changes_rounded,
      color: Color(0xFF0891B2),
      bgColor: Color(0xFFCFFAFE),
      badge: 'Live Status',
      route: AppRoutes.trackTicket,
    ),
    _ServiceItem(
      title: 'Manage Connections',
      subtitle: 'View, link or switch between all your SLT fixed & mobile accounts',
      category: 'Support',
      icon: Icons.device_hub_rounded,
      color: Color(0xFF4F46E5),
      bgColor: Color(0xFFE0E7FF),
      badge: 'Accounts',
      route: AppRoutes.connections,
    ),
  ];

  static void _openFiberPage(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FiberPage()),
    );
  }

  static void _openPeoTvGo(BuildContext context, WidgetRef ref) {
    launchPeoTvGoTokenFlow(context, ref);
  }

  static void _showMobitelInfo(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.signal_cellular_alt_rounded,
                    color: Color(0xFF0D9488),
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text('Mobitel Mobile', style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Experience Sri Lanka’s fastest mobile network with nationwide 4G/5G coverage, One-Shot Unlimited plans, prepaid/postpaid connections, and seamless eSIM activation.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.contactUs);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Contact Mobitel Support'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  static void _showVoiceInfo(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: Color(0xFF059669),
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text('Fixed Line Voice', style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'SLT Megaline and Fibre fixed voice services provide reliable landline telephone connectivity with crystal-clear voice clarity, caller ID, conference calling, and attractive domestic call tariffs.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.iddServices);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('View IDD & Calling Rates'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ServiceItem> get _filteredServices {
    return _allServices.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _handleServiceTap(_ServiceItem item) {
    if (item.onTap != null) {
      item.onTap!(context, ref);
    } else if (item.route != null) {
      context.push(item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredServices;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(
          'Services',
          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_rounded, color: Colors.white),
            tooltip: 'Contact Us',
            onPressed: () => context.push(AppRoutes.contactUs),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header search banner
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.md,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore SLT-Mobitel Services',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SearchBar(
                    controller: _searchController,
                    hintText: 'Search broadband, PEO TV, IDD, loans...',
                    hintStyle: WidgetStatePropertyAll(
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                    ),
                    leading: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                    trailing: [
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                    ],
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    elevation: const WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val.trim());
                    },
                  ),
                ],
              ),
            ),
          ),

          // Categories horizontal list
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.lg,
                AppSpacing.pagePadding,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories', style: AppTextStyles.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedCategory = cat);
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary.withValues(alpha: 0.12),
                          checkmarkColor: AppColors.primary,
                          labelStyle: AppTextStyles.labelMedium.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.borderLight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured banner card (New connection shortcut)
          if (_selectedCategory == 'All' && _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                  vertical: AppSpacing.sm,
                ),
                child: InkWell(
                  onTap: () => context.push(AppRoutes.newConnection),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.brandGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.speed_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Get a New Fibre Connection',
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Online identity check & instant coverage verification',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
            ),

          // Services grid list
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No matching services found',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Try searching with another keyword or change category.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = 'All';
                            _searchQuery = '';
                          });
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InkWell(
                        onTap: () => _handleServiceTap(item),
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(color: AppColors.borderLight),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: item.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item.icon, color: item.color, size: 24),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: AppTextStyles.titleSmall.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (item.badge != null) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item.color.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.badge!,
                                              style: AppTextStyles.caption.copyWith(
                                                color: item.color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.subtitle,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textTertiary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(
                            duration: 250.ms,
                            delay: Duration(milliseconds: (index % 6) * 40),
                          ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl2),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/idd_model.dart';

class IDDServicesPage extends StatefulWidget {
  const IDDServicesPage({super.key});

  @override
  State<IDDServicesPage> createState() => _IDDServicesPageState();
}

class _IDDServicesPageState extends State<IDDServicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  List<IDDRateModel> _filteredRates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredRates = MockData.iddRates;
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredRates = MockData.iddRates.where((rate) {
        return rate.countryName.toLowerCase().contains(query) ||
            rate.countryCode.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _activatePackage(IDDPackageModel pkg) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text('Activate ${pkg.name}?', style: AppTextStyles.headlineSmall),
        content: Text(
          'Confirm activation of ${pkg.name} for ${pkg.priceLabel}.\n\nValidity: ${pkg.validityDays} days\nIncludes: ${pkg.minutes} IDD minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pkg.name} activated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('IDD Services', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'IDD Rates'),
            Tab(text: 'IDD Packages'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // ── Tab 1: Rates ──
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: SearchBar(
                      controller: _searchCtrl,
                      hintText: 'Search country...',
                      leading: Icon(Icons.search_rounded, color: AppColors.textTertiary),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      elevation: WidgetStatePropertyAll(0),
                      side: WidgetStatePropertyAll(BorderSide(color: AppColors.borderLight)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _filteredRates.isEmpty
                        ? Center(
                            child: Text(
                              'No countries found',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                            itemCount: _filteredRates.length,
                            itemBuilder: (context, index) {
                              final rate = _filteredRates[index];
                              return Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: AppColors.borderLight),
                                ),
                                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: ListTile(
                                  leading: Text(rate.flag, style: TextStyle(fontSize: 28)),
                                  title: Text(
                                    rate.countryName,
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: rate.peakRate != null
                                      ? Text(
                                          'Peak: Rs.${rate.peakRate!.toStringAsFixed(2)} | Off-Peak: Rs.${rate.offPeakRate!.toStringAsFixed(2)}',
                                          style: AppTextStyles.caption,
                                        )
                                      : null,
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        rate.rateLabel,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(duration: 200.ms, delay: Duration(milliseconds: index * 40));
                            },
                          ),
                  ),
                ],
              ),

              // ── Tab 2: Packages ──
              ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: MockData.iddPackages.length,
                itemBuilder: (context, index) {
                  final pkg = MockData.iddPackages[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pkg.name,
                              style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (pkg.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Active',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(pkg.description, style: AppTextStyles.bodySmall),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price', style: AppTextStyles.caption),
                                Text(
                                  pkg.priceLabel,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Validity', style: AppTextStyles.caption),
                                Text('${pkg.validityDays} Days', style: AppTextStyles.titleSmall),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _activatePackage(pkg),
                              child: const Text('Buy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 250.ms, delay: Duration(milliseconds: index * 80));
                },
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(51),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

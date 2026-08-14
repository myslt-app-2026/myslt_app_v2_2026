import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/shop_location_model.dart';

class LocationServicesPage extends StatefulWidget {
  const LocationServicesPage({super.key});

  @override
  State<LocationServicesPage> createState() => _LocationServicesPageState();
}

class _LocationServicesPageState extends State<LocationServicesPage> {
  final _searchCtrl = TextEditingController();
  List<ShopLocationModel> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    _filteredShops = MockData.shopLocations;
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredShops = MockData.shopLocations.where((shop) {
        return shop.name.toLowerCase().contains(query) ||
            shop.city.toLowerCase().contains(query) ||
            shop.address.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _handleGetDirections(ShopLocationModel shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Google Maps directions to ${shop.name}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleCall(ShopLocationModel shop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling Teleshop: ${shop.phone}...'),
        backgroundColor: AppColors.success,
      ),
    );
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
        title: Text('Store Locator', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: SearchBar(
              controller: _searchCtrl,
              hintText: 'Search by city or outlet name...',
              leading: Icon(Icons.search_rounded, color: AppColors.textTertiary),
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(0),
              side: WidgetStatePropertyAll(BorderSide(color: AppColors.borderLight)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Outlets List
          Expanded(
            child: _filteredShops.isEmpty
                ? Center(
                    child: Text(
                      'No SLT shops found nearby',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
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
                                Expanded(
                                  child: Text(
                                    shop.name,
                                    style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: shop.isOpen ? AppColors.successLight : AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    shop.isOpen ? 'Open Now' : 'Closed',
                                    style: AppTextStyles.caption.copyWith(
                                      color: shop.isOpen ? AppColors.success : AppColors.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(shop.address, style: AppTextStyles.bodySmall),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Icon(Icons.access_time_filled_rounded, size: 14, color: AppColors.textTertiary),
                                const SizedBox(width: 6),
                                Text(shop.hours, style: AppTextStyles.caption),
                                const Spacer(),
                                if (shop.distanceLabel.isNotEmpty) ...[
                                  Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(shop.distanceLabel, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Divider(height: 1, color: AppColors.dividerLight),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _handleCall(shop),
                                  icon: Icon(Icons.phone_rounded, size: 16),
                                  label: const Text('Call'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.success,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                ElevatedButton.icon(
                                  onPressed: () => _handleGetDirections(shop),
                                  icon: Icon(Icons.directions_rounded, size: 16),
                                  label: const Text('Directions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 250.ms, delay: Duration(milliseconds: index * 80));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

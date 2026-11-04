import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/address_provider.dart';
import '../widgets/order_summary_bar.dart';

/// Step 4 of the new-connection flow: Address & Fibre availability check.
class CheckAvailabilityScreen extends ConsumerStatefulWidget {
  const CheckAvailabilityScreen({super.key});

  @override
  ConsumerState<CheckAvailabilityScreen> createState() =>
      _CheckAvailabilityScreenState();
}

class _CheckAvailabilityScreenState
    extends ConsumerState<CheckAvailabilityScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _cityController;
  String _selectedDistrict = 'Gampaha';

  @override
  void initState() {
    super.initState();
    final address = ref.read(addressProvider);
    _streetController =
        TextEditingController(text: address.houseNumberAndStreet);
    _landmarkController =
        TextEditingController(text: address.apartmentLandmark);
    _cityController = TextEditingController(text: address.city);
    _selectedDistrict = address.district;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _syncDetails() {
    ref.read(addressProvider.notifier).update(
          houseNumberAndStreet: _streetController.text,
          apartmentLandmark: _landmarkController.text,
          city: _cityController.text,
          district: _selectedDistrict,
        );
  }

  Future<void> _checkAvailability() async {
    _syncDetails();
    await ref.read(addressProvider.notifier).checkAvailability();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fibre coverage confirmed for your address!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _syncDetails();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Installation time selection coming soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final address = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New connection'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Text(
              'Step 4 of 7',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 4 / 7,
                minHeight: 5,
                backgroundColor: colors.outlineVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Check availability',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the address where you want your new connection.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Installation address',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),

            // House number and street
            TextFormField(
              controller: _streetController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'House number and street',
                labelStyle: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              onChanged: (_) => _syncDetails(),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter house number and street';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Apartment, floor or landmark (optional)
            TextFormField(
              controller: _landmarkController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Apartment, floor or landmark (optional)',
                hintStyle: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              onChanged: (_) => _syncDetails(),
            ),
            const SizedBox(height: 16),

            // City / town
            TextFormField(
              controller: _cityController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'City / town',
                labelStyle: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              onChanged: (_) => _syncDetails(),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter city / town';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // District dropdown
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                labelText: 'District',
                labelStyle: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF94A3B8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              items: sriLankaDistricts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(
                    district,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newDistrict) {
                if (newDistrict != null) {
                  setState(() {
                    _selectedDistrict = newDistrict;
                  });
                  _syncDetails();
                }
              },
            ),
            const SizedBox(height: 20),

            // Check fibre availability button
            OutlinedButton(
              onPressed: address.isChecking ? null : _checkAvailability,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: address.isChecking
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_rounded,
                          color: colors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Check fibre availability',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
            ),

            // Result banner
            if (address.isFibreAvailable == true) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sample result: fibre available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Continue to choose an installation time.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: OrderSummaryBar(
        onContinue: _handleContinue,
      ),
    );
  }
}


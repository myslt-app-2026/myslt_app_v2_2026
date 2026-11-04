import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/address_provider.dart';
import '../widgets/order_summary_bar.dart';
import '../widgets/step_progress_bar.dart';

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
  String? _selectedDistrict;

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
          houseNumberAndStreet: _streetController.text.trim(),
          apartmentLandmark: _landmarkController.text.trim(),
          city: _cityController.text.trim(),
          district: _selectedDistrict,
        );
  }

  Future<void> _checkAvailability() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in your address and select a district first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _syncDetails();

    final result = await ref.read(addressProvider.notifier).checkAvailability(
          street: _streetController.text.trim(),
          landmark: _landmarkController.text.trim(),
          city: _cityController.text.trim(),
          district: _selectedDistrict!,
        );

    if (!mounted) return;

    if (result.available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fibre coverage confirmed for your address!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final address = ref.read(addressProvider);
    if (address.coverageResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check fibre availability before continuing.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!address.coverageResult!.available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fibre coverage is not available at this address. Please check your address or contact SLT.'),
          duration: Duration(seconds: 3),
        ),
      );
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
            const StepProgressBar(currentStep: 4),
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
                hintText: 'e.g. No. 55, Main Street',
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                  fontSize: 14,
                ),
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
                labelText: 'Apartment, floor or landmark (optional)',
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
                hintText: 'e.g. Negombo',
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                  fontSize: 14,
                ),
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
              hint: const Text(
                'Select district',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
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
                setState(() {
                  _selectedDistrict = newDistrict;
                });
                _syncDetails();
              },
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please select a district';
                }
                return null;
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

            // Dynamic coverage result banner (shown only after check is performed)
            if (address.coverageResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: address.coverageResult!.available
                      ? const Color(0xFFE8F7ED)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: address.coverageResult!.available
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFCA5A5),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: address.coverageResult!.available
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        address.coverageResult!.available
                            ? Icons.check
                            : Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.coverageResult!.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.coverageResult!.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: address.coverageResult!.available
                                  ? const Color(0xFF334155)
                                  : const Color(0xFF7F1D1D),
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

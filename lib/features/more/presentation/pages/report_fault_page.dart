import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/fault_report_model.dart';

class ReportFaultPage extends StatefulWidget {
  const ReportFaultPage({super.key});

  @override
  State<ReportFaultPage> createState() => _ReportFaultPageState();
}

class _ReportFaultPageState extends State<ReportFaultPage> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(text: '0771234567');
  FaultCategory _selectedCategory = FaultCategory.noInternet;
  bool _isLoading = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Generate random Ticket ID
    final randomNum = Random().nextInt(90000) + 10000;
    final ticketId = 'FLT-$randomNum';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success),
            const SizedBox(width: 8),
            Text('Fault Reported', style: AppTextStyles.headlineSmall),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your complaint has been successfully registered.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('Ticket Reference Number', style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(
                    ticketId,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A technician will contact you shortly on ${_phoneCtrl.text}.',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
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
        title: Text('Report Fault', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('Select Issue Category', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.md),

              // Category Selector Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.0,
                ),
                itemCount: FaultCategory.values.length,
                itemBuilder: (context, index) {
                  final cat = FaultCategory.values[index];
                  final isSelected = _selectedCategory == cat;
                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? cat.color.withAlpha(20) : Colors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                        border: Border.all(
                          color: isSelected ? cat.color : AppColors.borderLight,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            cat.icon,
                            color: isSelected ? cat.color : AppColors.textTertiary,
                            size: 26,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.label,
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected ? cat.color : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),

              // Description Text Area
              Text('Describe Your Issue', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe details such as indicator light status, when the issue started, etc.',
                  hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Please enter at least 10 characters description.';
                  }
                  return null;
                },
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.xl),

              // Contact Number
              Text('Contact Details', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _phoneCtrl,
                label: 'Callback Phone Number',
                hint: '07X XXX XXXX',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return null;
                },
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.xl3),

              // Action button
              AppButton(
                label: 'Submit Ticket',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}

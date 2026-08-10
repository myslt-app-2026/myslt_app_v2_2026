import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class HappyDayPage extends StatefulWidget {
  const HappyDayPage({super.key});

  @override
  State<HappyDayPage> createState() => _HappyDayPageState();
}

class _HappyDayPageState extends State<HappyDayPage> {
  bool _isRevealed = false;
  bool _isClaimed = false;
  bool _isLoading = false;

  final String _prizeTitle = '5 GB FREE Data';
  final String _prizeSubtitle = 'Happy Day Weekly Bonus';
  final String _prizeValidity = 'Valid for 24 Hours';

  Future<void> _handleClaim() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isClaimed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('5 GB free data has been added to your account!'),
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
        title: Text('Happy Day Rewards', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Weekly Mystery Reward',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tap the card below to reveal your prize. Rewards refresh every Friday!',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              const SizedBox(height: AppSpacing.xl2),

              // Interactive Scratch/Reveal Card
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (!_isRevealed) {
                        setState(() => _isRevealed = true);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutBack,
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 320),
                      decoration: BoxDecoration(
                        gradient: _isRevealed
                            ? const LinearGradient(
                                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFEC4899), Color(0xFFD946EF), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                        boxShadow: [
                          BoxShadow(
                            color: (_isRevealed ? Colors.black : const Color(0xFFEC4899)).withAlpha(76),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: _isRevealed ? Colors.white24 : Colors.white60,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Sparkles
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withAlpha(20),
                                ),
                              ),
                            ),
                            // Hidden / Revealed State Card Content
                            Center(
                              child: _isRevealed
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.stars_rounded, color: Colors.amber, size: 64)
                                            .animate()
                                            .scale(duration: 400.ms, curve: Curves.elasticOut),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          _prizeTitle,
                                          style: AppTextStyles.headlineMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                                        Text(
                                          _prizeSubtitle,
                                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                                        ).animate().fadeIn(delay: 300.ms),
                                        const SizedBox(height: AppSpacing.sm),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            _prizeValidity,
                                            style: AppTextStyles.caption.copyWith(color: Colors.amber),
                                          ),
                                        ).animate().fadeIn(delay: 450.ms),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.help_outline_rounded, color: Colors.white, size: 56)
                                            .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                            .shake(hz: 2, curve: Curves.easeInOut),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          'Tap to Scratch',
                                          style: AppTextStyles.titleMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Find out your weekly surprise!',
                                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl2),

              // Action buttons & countdown
              if (_isRevealed) ...[
                if (!_isClaimed)
                  AppButton(
                    label: 'Claim Reward',
                    onPressed: _handleClaim,
                    isLoading: _isLoading,
                  ).animate().fadeIn().slideY(begin: 0.1)
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(
                          'Reward Claimed Successfully!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Countdown Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Next reward unlocks in: 4d 18h 32m',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

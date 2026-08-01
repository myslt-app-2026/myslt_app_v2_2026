import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Button variant types for [AppButton].
enum AppButtonVariant { primary, secondary, outline, ghost, danger }

/// A versatile, animated button component for the mySLT design system.
///
/// Supports primary, secondary, outline, and ghost variants with
/// animated loading state and press scale effect.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? width;
  final double height;
  final double? borderRadius;

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum IconPosition { left, right }

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  bool get _isInteractable =>
      !widget.isLoading && !widget.isDisabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isInteractable ? (_) => _scaleController.forward() : null,
      onTapUp: _isInteractable
          ? (_) async {
              await _scaleController.reverse();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final radius = widget.borderRadius ?? AppSpacing.buttonRadius;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width ?? double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: _isInteractable ? _gradient : null,
        color: _isInteractable ? null : _disabledColor,
        border: _border,
        boxShadow: _isInteractable && widget.variant == AppButtonVariant.primary
            ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(51),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_contentColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null &&
                          widget.iconPosition == IconPosition.left) ...[
                        Icon(widget.icon, color: _contentColor, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: AppTextStyles.button.copyWith(
                          color: _contentColor,
                        ),
                      ),
                      if (widget.icon != null &&
                          widget.iconPosition == IconPosition.right) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(widget.icon, color: _contentColor, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  LinearGradient? get _gradient {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      case AppButtonVariant.danger:
        return const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
      default:
        return null;
    }
  }

  Color? get _disabledColor {
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return AppColors.textDisabled;
      case AppButtonVariant.secondary:
        return AppColors.backgroundLight;
      default:
        return Colors.transparent;
    }
  }

  Color get _contentColor {
    if (!_isInteractable) return AppColors.textTertiary;
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.outline:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return AppColors.primary;
    }
  }

  BoxBorder? get _border {
    switch (widget.variant) {
      case AppButtonVariant.outline:
        return Border.all(
          color: _isInteractable ? AppColors.primary : AppColors.borderLight,
          width: 1.5,
        );
      default:
        return null;
    }
  }
}

/// A compact icon-only button with tap animation.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = AppSpacing.iconMd,
    this.padding = AppSpacing.sm,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double padding;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSm),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Icon(
              icon,
              size: size,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Custom badge widget
class BadgeWidget extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSmall;

  const BadgeWidget({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isSmall = false,
  });

  /// Sale badge
  factory BadgeWidget.sale(String text) {
    return BadgeWidget(
      text: text,
      backgroundColor: AppColors.sale,
      textColor: Colors.white,
    );
  }

  /// New badge
  factory BadgeWidget.newItem() {
    return const BadgeWidget(
      text: 'NEW',
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }

  /// Featured badge
  factory BadgeWidget.featured() {
    return BadgeWidget(
      text: 'FEATURED',
      backgroundColor: AppColors.tertiary,
      textColor: Colors.white,
    );
  }

  /// Stock badge
  factory BadgeWidget.inStock() {
    return const BadgeWidget(
      text: 'In Stock',
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
    );
  }

  /// Out of stock badge
  factory BadgeWidget.outOfStock() {
    return const BadgeWidget(
      text: 'Out of Stock',
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.xs : AppSpacing.sm,
        vertical: isSmall ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryContainer,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      child: Text(
        text,
        style: (isSmall ? AppTypography.labelSmall : AppTypography.badge).copyWith(
          color: textColor ?? AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

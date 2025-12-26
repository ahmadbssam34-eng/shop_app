import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Price display widget with discount support
class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final bool isLarge;
  final CrossAxisAlignment alignment;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.isLarge = false,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    if (isLarge) {
      return Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: AppTypography.priceLarge,
              ),
              if (hasDiscount) ...[
                AppSpacing.horizontalGapSm,
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '\$${originalPrice!.toStringAsFixed(2)}',
                    style: AppTypography.priceOriginal.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
          if (hasDiscount) ...[
            AppSpacing.verticalGapXs,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: AppSpacing.borderRadiusXs,
              ),
              child: Text(
                'Save \$${(originalPrice! - price).toStringAsFixed(2)}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: AppTypography.price,
        ),
        if (hasDiscount) ...[
          AppSpacing.horizontalGapSm,
          Text(
            '\$${originalPrice!.toStringAsFixed(2)}',
            style: AppTypography.priceOriginal,
          ),
        ],
      ],
    );
  }
}

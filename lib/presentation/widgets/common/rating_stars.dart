import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Rating stars widget
class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;
  final bool showText;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          IconData icon;
          Color color;

          if (rating >= starValue) {
            icon = Icons.star_rounded;
            color = AppColors.rating;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
            color = AppColors.rating;
          } else {
            icon = Icons.star_outline_rounded;
            color = AppColors.border;
          }

          return Icon(icon, size: size, color: color);
        }),
        if (showText) ...[
          AppSpacing.horizontalGapSm,
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.labelMedium,
          ),
          if (reviewCount != null) ...[
            AppSpacing.horizontalGapXs,
            Text(
              '($reviewCount reviews)',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// Interactive rating selector
class RatingSelector extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onChanged;
  final double size;

  const RatingSelector({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () => onChanged?.call(starValue.toDouble()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              rating >= starValue ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: rating >= starValue ? AppColors.rating : AppColors.border,
            ),
          ),
        );
      }),
    );
  }
}

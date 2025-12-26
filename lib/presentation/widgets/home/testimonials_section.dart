import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/section_header.dart';
import '../common/rating_stars.dart';

/// Testimonials section
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      _Testimonial(
        name: 'Sarah Johnson',
        role: 'Verified Buyer',
        rating: 5.0,
        comment: 'Amazing quality products! Fast shipping and excellent customer service. Will definitely shop here again.',
        avatar: 'SJ',
      ),
      _Testimonial(
        name: 'Michael Chen',
        role: 'Verified Buyer',
        rating: 5.0,
        comment: 'Best phone accessories store I have found online. Great prices and the products are exactly as described.',
        avatar: 'MC',
      ),
      _Testimonial(
        name: 'Emily Davis',
        role: 'Verified Buyer',
        rating: 4.5,
        comment: 'Love my new earbuds! The sound quality is incredible for the price. Highly recommend this store.',
        avatar: 'ED',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'What Our Customers Say',
          subtitle: 'Real reviews from real customers',
        ),
        AppSpacing.verticalGapLg,
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalLg,
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => AppSpacing.horizontalGapMd,
            itemBuilder: (context, index) {
              return _TestimonialCard(testimonial: testimonials[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _Testimonial {
  final String name;
  final String role;
  final double rating;
  final String comment;
  final String avatar;

  const _Testimonial({
    required this.name,
    required this.role,
    required this.rating,
    required this.comment,
    required this.avatar,
  });
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    testimonial.avatar,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: AppTypography.titleSmall,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: AppColors.success,
                        ),
                        AppSpacing.horizontalGapXs,
                        Text(
                          testimonial.role,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          RatingStars(rating: testimonial.rating, showText: false, size: 18),
          AppSpacing.verticalGapMd,
          Expanded(
            child: Text(
              '"${testimonial.comment}"',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

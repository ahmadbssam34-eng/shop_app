import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_button.dart';

/// Hero section for home page
class HeroSection extends StatelessWidget {
  final VoidCallback? onShopNow;

  const HeroSection({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > AppSpacing.tabletBreakpoint;

    return Container(
      margin: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBadge(),
          AppSpacing.verticalGapLg,
          _buildTitle(),
          AppSpacing.verticalGapMd,
          _buildSubtitle(),
          AppSpacing.verticalGapXxl,
          _buildCTA(),
          AppSpacing.verticalGapXxl,
          _buildFeatures(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxxl),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadge(),
                AppSpacing.verticalGapLg,
                _buildTitle(isLarge: true),
                AppSpacing.verticalGapMd,
                _buildSubtitle(),
                AppSpacing.verticalGapXxl,
                _buildCTA(),
                AppSpacing.verticalGapXxxl,
                _buildFeatures(),
              ],
            ),
          ),
          AppSpacing.horizontalGapXxl,
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Center(
                child: Icon(
                  Icons.devices,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: AppSpacing.borderRadiusRound,
      ),
      child: Text(
        'NEW COLLECTION 2024',
        style: AppTypography.labelMedium.copyWith(
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTitle({bool isLarge = false}) {
    return Text(
      'Premium Gadgets\nFor Modern Life',
      style: (isLarge ? AppTypography.displaySmall : AppTypography.headlineLarge).copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Discover our curated selection of phone accessories and home tools. Quality meets style.',
      style: AppTypography.bodyLarge.copyWith(
        color: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildCTA() {
    return Row(
      children: [
        AppButton(
          text: 'Shop Now',
          onPressed: onShopNow,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          icon: Icons.arrow_forward,
          width: 160,
        ),
        AppSpacing.horizontalGapMd,
        AppButton(
          text: 'Learn More',
          onPressed: () {},
          isOutlined: true,
          foregroundColor: Colors.white,
          width: 140,
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    return Row(
      children: [
        _buildFeatureItem(Icons.local_shipping_outlined, 'Free Shipping'),
        AppSpacing.horizontalGapXxl,
        _buildFeatureItem(Icons.verified_outlined, '2 Year Warranty'),
        AppSpacing.horizontalGapXxl,
        _buildFeatureItem(Icons.replay_outlined, 'Easy Returns'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 18),
        AppSpacing.horizontalGapSm,
        Text(
          text,
          style: AppTypography.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

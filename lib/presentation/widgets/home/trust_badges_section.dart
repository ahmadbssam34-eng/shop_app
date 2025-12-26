import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Trust badges section
class TrustBadgesSection extends StatelessWidget {
  const TrustBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    final badges = [
      _TrustBadge(
        icon: Icons.local_shipping_outlined,
        title: 'Free Shipping',
        subtitle: 'On orders over \$50',
      ),
      _TrustBadge(
        icon: Icons.replay_outlined,
        title: '30-Day Returns',
        subtitle: 'Easy & hassle-free',
      ),
      _TrustBadge(
        icon: Icons.security_outlined,
        title: 'Secure Payment',
        subtitle: '100% protected',
      ),
      _TrustBadge(
        icon: Icons.support_agent_outlined,
        title: '24/7 Support',
        subtitle: 'Always here to help',
      ),
    ];

    return Container(
      margin: AppSpacing.screenPadding,
      padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: badges.map((badge) => Expanded(child: badge)).toList(),
            )
          : Wrap(
              alignment: WrapAlignment.center,
              runSpacing: AppSpacing.lg,
              children: badges
                  .map((badge) => SizedBox(
                        width: (screenWidth - AppSpacing.lg * 4) / 2,
                        child: badge,
                      ))
                  .toList(),
            ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        AppSpacing.verticalGapMd,
        Text(
          title,
          style: AppTypography.titleSmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalGapXs,
        Text(
          subtitle,
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

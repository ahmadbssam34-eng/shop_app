import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Footer section
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Container(
      color: AppColors.textPrimary,
      padding: EdgeInsets.all(isWide ? AppSpacing.xxxxl : AppSpacing.xxl),
      child: Column(
        children: [
          isWide ? _buildWideContent() : _buildMobileContent(),
          AppSpacing.verticalGapXxxl,
          const Divider(color: AppColors.textTertiary, height: 1),
          AppSpacing.verticalGapXxl,
          _buildBottomBar(isWide),
        ],
      ),
    );
  }

  Widget _buildWideContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildBrandSection()),
        Expanded(child: _buildLinksSection('Shop', _shopLinks)),
        Expanded(child: _buildLinksSection('Support', _supportLinks)),
        Expanded(child: _buildLinksSection('Company', _companyLinks)),
        Expanded(child: _buildContactSection()),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandSection(),
        AppSpacing.verticalGapXxxl,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLinksSection('Shop', _shopLinks)),
            Expanded(child: _buildLinksSection('Support', _supportLinks)),
          ],
        ),
        AppSpacing.verticalGapXxl,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLinksSection('Company', _companyLinks)),
            Expanded(child: _buildContactSection()),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 24,
              ),
            ),
            AppSpacing.horizontalGapMd,
            Text(
              'Gadget Market',
              style: AppTypography.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGapLg,
        Text(
          'Your one-stop shop for premium phone accessories and home tools. Quality products, great prices.',
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        AppSpacing.verticalGapLg,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialIcon(Icons.facebook),
            AppSpacing.horizontalGapSm,
            _buildSocialIcon(Icons.linked_camera),
            AppSpacing.horizontalGapSm,
            _buildSocialIcon(Icons.yard_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white.withValues(alpha: 0.8),
        size: 20,
      ),
    );
  }

  Widget _buildLinksSection(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            color: Colors.white,
          ),
        ),
        AppSpacing.verticalGapLg,
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            link,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: AppTypography.titleSmall.copyWith(
            color: Colors.white,
          ),
        ),
        AppSpacing.verticalGapLg,
        _buildContactItem(Icons.email_outlined, 'support@gadgetmarket.com'),
        AppSpacing.verticalGapSm,
        _buildContactItem(Icons.phone_outlined, '+1 (555) 123-4567'),
        AppSpacing.verticalGapSm,
        _buildContactItem(Icons.location_on_outlined, 'San Francisco, CA'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.7),
          size: 18,
        ),
        AppSpacing.horizontalGapSm,
        Flexible(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isWide) {
    final year = DateTime.now().year;
    
    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\u00A9 $year Gadget Market. All rights reserved.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Row(
            children: [
              _buildBottomLink('Privacy Policy'),
              AppSpacing.horizontalGapLg,
              _buildBottomLink('Terms of Service'),
              AppSpacing.horizontalGapLg,
              _buildBottomLink('Cookie Policy'),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBottomLink('Privacy'),
            AppSpacing.horizontalGapMd,
            _buildBottomLink('Terms'),
            AppSpacing.horizontalGapMd,
            _buildBottomLink('Cookies'),
          ],
        ),
        AppSpacing.verticalGapMd,
        Text(
          '\u00A9 $year Gadget Market. All rights reserved.',
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomLink(String text) {
    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(
        color: Colors.white.withValues(alpha: 0.5),
      ),
    );
  }

  static const _shopLinks = [
    'Phone Cases',
    'Chargers & Cables',
    'Audio',
    'Power Banks',
    'Home Tools',
  ];

  static const _supportLinks = [
    'Help Center',
    'Shipping Info',
    'Returns',
    'Track Order',
    'Contact Us',
  ];

  static const _companyLinks = [
    'About Us',
    'Careers',
    'Press',
    'Blog',
    'Affiliates',
  ];
}

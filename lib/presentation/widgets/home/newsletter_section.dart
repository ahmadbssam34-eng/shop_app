import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_button.dart';

/// Newsletter signup section
class NewsletterSection extends StatefulWidget {
  const NewsletterSection({super.key});

  @override
  State<NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<NewsletterSection> {
  final _emailController = TextEditingController();
  bool _isSubscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _subscribe() {
    if (_emailController.text.isNotEmpty) {
      setState(() => _isSubscribed = true);
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Container(
      margin: AppSpacing.screenPadding,
      padding: EdgeInsets.all(isWide ? AppSpacing.xxxxl : AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        children: [
          Icon(
            Icons.mail_outline,
            color: Colors.white.withValues(alpha: 0.8),
            size: 48,
          ),
          AppSpacing.verticalGapLg,
          Text(
            'Subscribe to Our Newsletter',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGapSm,
          Text(
            'Get exclusive deals, new product alerts, and 10% off your first order!',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGapXxl,
          if (_isSubscribed)
            Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  AppSpacing.horizontalGapMd,
                  Text(
                    'Thank you for subscribing!',
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            isWide
                ? _buildWideInput()
                : _buildMobileInput(),
        ],
      ),
    );
  }

  Widget _buildWideInput() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Row(
        children: [
          Expanded(child: _buildEmailField()),
          AppSpacing.horizontalGapMd,
          AppButton(
            text: 'Subscribe',
            onPressed: _subscribe,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            width: 140,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInput() {
    return Column(
      children: [
        _buildEmailField(),
        AppSpacing.verticalGapMd,
        AppButton(
          text: 'Subscribe',
          onPressed: _subscribe,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

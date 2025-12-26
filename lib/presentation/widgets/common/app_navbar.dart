import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/cart_provider.dart';
import 'app_button.dart';

/// App navigation bar (sticky)
class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogoTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCategoryTap;
  final VoidCallback? onAccountTap;
  final VoidCallback? onCartTap;
  final bool showSearch;

  const AppNavbar({
    super.key,
    this.onLogoTap,
    this.onSearchTap,
    this.onCategoryTap,
    this.onAccountTap,
    this.onCartTap,
    this.showSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Logo
              _buildLogo(),
              
              if (isWide) ...[
                AppSpacing.horizontalGapXxxl,
                // Navigation links
                _buildNavLinks(),
                const Spacer(),
                // Search bar
                if (showSearch)
                  SizedBox(
                    width: 300,
                    child: _buildSearchBar(context),
                  ),
                AppSpacing.horizontalGapLg,
              ] else ...[
                const Spacer(),
                if (showSearch)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: onSearchTap,
                    color: AppColors.textPrimary,
                  ),
              ],
              
              // Account
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: onAccountTap,
                color: AppColors.textPrimary,
              ),
              
              // Cart with badge
              Consumer<CartProvider>(
                builder: (context, cart, _) {
                  return AppIconButton(
                    icon: Icons.shopping_cart_outlined,
                    onPressed: onCartTap,
                    badgeCount: cart.itemCount,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return GestureDetector(
      onTap: onLogoTap,
      child: Row(
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
              size: 20,
            ),
          ),
          AppSpacing.horizontalGapSm,
          Text(
            'Gadget Market',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavLink(text: 'Home', onTap: onLogoTap),
        _NavLink(text: 'Shop', onTap: onCategoryTap),
        _NavLink(text: 'Categories', onTap: onCategoryTap),
        _NavLink(text: 'Deals', onTap: () {}),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusRound,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: AppColors.textTertiary,
            ),
            AppSpacing.horizontalGapSm,
            Text(
              'Search products...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const _NavLink({required this.text, this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            widget.text,
            style: AppTypography.labelLarge.copyWith(
              color: _isHovered ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile bottom navigation bar
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view),
                  label: 'Shop',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: cart.itemCount > 0,
                    label: Text(cart.itemCount.toString()),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: cart.itemCount > 0,
                    label: Text(cart.itemCount.toString()),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

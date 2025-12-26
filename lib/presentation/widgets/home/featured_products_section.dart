import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/product.dart';
import '../common/section_header.dart';
import '../common/product_card.dart';

/// Featured products grid section
class FeaturedProductsSection extends StatelessWidget {
  final List<Product> products;
  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;

  const FeaturedProductsSection({
    super.key,
    required this.products,
    this.title = 'Featured Products',
    this.subtitle,
    this.onViewAll,
    this.onProductTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          subtitle: subtitle,
          actionText: 'View All',
          actionIcon: Icons.arrow_forward,
          onAction: onViewAll,
        ),
        AppSpacing.verticalGapLg,
        _buildProductGrid(screenWidth),
      ],
    );
  }

  Widget _buildProductGrid(double screenWidth) {
    // Responsive grid
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > AppSpacing.desktopBreakpoint) {
      crossAxisCount = 4;
      childAspectRatio = 0.65;
    } else if (screenWidth > AppSpacing.tabletBreakpoint) {
      crossAxisCount = 3;
      childAspectRatio = 0.65;
    } else if (screenWidth > AppSpacing.mobileBreakpoint) {
      crossAxisCount = 2;
      childAspectRatio = 0.65;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.58;
    }

    return Padding(
      padding: AppSpacing.paddingHorizontalLg,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => onProductTap?.call(product),
            onAddToCart: () => onAddToCart?.call(product),
          );
        },
      ),
    );
  }
}

/// Horizontal scrolling products section
class HorizontalProductsSection extends StatelessWidget {
  final List<Product> products;
  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;

  const HorizontalProductsSection({
    super.key,
    required this.products,
    this.title = 'New Arrivals',
    this.subtitle,
    this.onViewAll,
    this.onProductTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          subtitle: subtitle,
          actionText: 'View All',
          actionIcon: Icons.arrow_forward,
          onAction: onViewAll,
        ),
        AppSpacing.verticalGapLg,
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalLg,
            itemCount: products.length,
            separatorBuilder: (_, __) => AppSpacing.horizontalGapMd,
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: 200,
                child: ProductCard(
                  product: product,
                  onTap: () => onProductTap?.call(product),
                  onAddToCart: () => onAddToCart?.call(product),
                  isCompact: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

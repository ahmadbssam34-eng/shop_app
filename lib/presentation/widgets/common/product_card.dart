import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product.dart';

/// Premium product card with hover effects
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool showAddToCart;
  final bool isCompact;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.showAddToCart = true,
    this.isCompact = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: _isHovered ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              _buildImage(),
              // Content
              Padding(
                padding: widget.isCompact 
                    ? AppSpacing.cardPaddingSmall 
                    : AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      widget.product.name,
                      style: widget.isCompact 
                          ? AppTypography.titleSmall 
                          : AppTypography.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.verticalGapXs,
                    // Rating
                    _buildRating(),
                    AppSpacing.verticalGapSm,
                    // Price
                    _buildPrice(),
                    if (widget.showAddToCart && !widget.isCompact) ...[
                      AppSpacing.verticalGapMd,
                      // Add to Cart Button
                      _buildAddToCartButton(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusMd),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.product.primaryImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textTertiary,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        // Badges
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product.hasDiscount)
                _buildBadge(
                  '-${widget.product.discountPercentage}%',
                  AppColors.sale,
                ),
              if (widget.product.isNew) ...[
                if (widget.product.hasDiscount) AppSpacing.verticalGapXs,
                _buildBadge('NEW', AppColors.primary),
              ],
            ],
          ),
        ),
        // Wishlist button
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isHovered ? 1 : 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border, size: 20),
                onPressed: () {},
                color: AppColors.textSecondary,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      child: Text(
        text,
        style: AppTypography.badge,
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          size: 16,
          color: AppColors.rating,
        ),
        AppSpacing.horizontalGapXs,
        Text(
          widget.product.rating.toStringAsFixed(1),
          style: AppTypography.labelMedium,
        ),
        AppSpacing.horizontalGapXs,
        Text(
          '(${widget.product.reviewCount})',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: widget.isCompact 
              ? AppTypography.price.copyWith(fontSize: 16) 
              : AppTypography.price,
        ),
        if (widget.product.hasDiscount) ...[
          AppSpacing.horizontalGapSm,
          Text(
            '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
            style: AppTypography.priceOriginal,
          ),
        ],
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeightMd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: widget.onAddToCart,
          icon: const Icon(Icons.add_shopping_cart, size: 18),
          label: const Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.primary : AppColors.primaryContainer,
            foregroundColor: _isHovered ? Colors.white : AppColors.primary,
            elevation: 0,
            textStyle: AppTypography.button,
          ),
        ),
      ),
    );
  }
}

/// Horizontal product card for cart/checkout
class ProductCardHorizontal extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;
  final String? selectedColor;
  final String? selectedVariant;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.selectedColor,
    this.selectedVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusSm,
            child: CachedNetworkImage(
              imageUrl: product.primaryImage,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceVariant,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          AppSpacing.horizontalGapMd,
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTypography.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onRemove != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: onRemove,
                        color: AppColors.textTertiary,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
                if (selectedColor != null || selectedVariant != null) ...[
                  AppSpacing.verticalGapXs,
                  Text(
                    [
                      if (selectedColor != null) selectedColor,
                      if (selectedVariant != null) selectedVariant,
                    ].join(' / '),
                    style: AppTypography.bodySmall,
                  ),
                ],
                AppSpacing.verticalGapSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.price.copyWith(fontSize: 16),
                        ),
                        if (product.hasDiscount)
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(2)}',
                            style: AppTypography.priceOriginal.copyWith(fontSize: 12),
                          ),
                      ],
                    ),
                    // Quantity controls
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.borderRadiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: onDecrement,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              quantity.toString(),
                              style: AppTypography.titleSmall,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: onIncrement,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/cart_provider.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/common/app_button.dart';

/// Cart screen with quantity controls and order summary
class CartScreen extends StatelessWidget {
  final VoidCallback? onCheckout;
  final VoidCallback? onContinueShopping;

  const CartScreen({
    super.key,
    this.onCheckout,
    this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.isEmpty) {
          return _buildEmptyCart(context);
        }

        if (isWide) {
          return _buildDesktopLayout(context, cart);
        }
        return _buildMobileLayout(context, cart);
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalGapXxl,
            Text(
              'Your cart is empty',
              style: AppTypography.headlineSmall,
            ),
            AppSpacing.verticalGapMd,
            Text(
              'Looks like you haven\'t added anything to your cart yet.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapXxxl,
            AppButton(
              text: 'Start Shopping',
              icon: Icons.shopping_bag_outlined,
              onPressed: onContinueShopping,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        // Cart Items
        Expanded(
          child: ListView.separated(
            padding: AppSpacing.paddingLg,
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => AppSpacing.verticalGapMd,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ProductCardHorizontal(
                product: item.product,
                quantity: item.quantity,
                selectedColor: item.selectedColor,
                selectedVariant: item.selectedVariant,
                onIncrement: () => cart.incrementQuantity(item.product.id),
                onDecrement: () => cart.decrementQuantity(item.product.id),
                onRemove: () => _confirmRemove(context, cart, item.product.id),
              );
            },
          ),
        ),
        
        // Order Summary
        _buildOrderSummary(context, cart),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Items
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shopping Cart (${cart.uniqueItemCount} items)',
                  style: AppTypography.headlineSmall,
                ),
                AppSpacing.verticalGapXxl,
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => AppSpacing.verticalGapMd,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ProductCardHorizontal(
                        product: item.product,
                        quantity: item.quantity,
                        selectedColor: item.selectedColor,
                        selectedVariant: item.selectedVariant,
                        onIncrement: () => cart.incrementQuantity(item.product.id),
                        onDecrement: () => cart.decrementQuantity(item.product.id),
                        onRemove: () => _confirmRemove(context, cart, item.product.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGapXxxl,
          // Order Summary Card
          SizedBox(
            width: 360,
            child: _buildOrderSummaryCard(context, cart),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: AppSpacing.cardPadding,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Savings banner
            if (cart.hasSavings)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.celebration, color: AppColors.success, size: 18),
                    AppSpacing.horizontalGapSm,
                    Text(
                      'You\'re saving \$${cart.totalSavings.toStringAsFixed(2)}!',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Summary rows
            _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
            AppSpacing.verticalGapSm,
            _buildSummaryRow(
              'Shipping',
              cart.shippingCost == 0 ? 'FREE' : '\$${cart.shippingCost.toStringAsFixed(2)}',
              isHighlight: cart.shippingCost == 0,
            ),
            AppSpacing.verticalGapSm,
            _buildSummaryRow('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
            AppSpacing.verticalGapMd,
            const Divider(),
            AppSpacing.verticalGapMd,
            _buildSummaryRow(
              'Total',
              '\$${cart.total.toStringAsFixed(2)}',
              isBold: true,
            ),
            AppSpacing.verticalGapLg,
            
            // Checkout button
            AppButton(
              text: 'Proceed to Checkout',
              icon: Icons.lock_outline,
              onPressed: onCheckout,
            ),
            AppSpacing.verticalGapMd,
            TextButton(
              onPressed: onContinueShopping,
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, CartProvider cart) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Order Summary', style: AppTypography.titleLarge),
          AppSpacing.verticalGapXxl,
          
          // Savings banner
          if (cart.hasSavings)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration, color: AppColors.success, size: 20),
                  AppSpacing.horizontalGapMd,
                  Text(
                    'You\'re saving \$${cart.totalSavings.toStringAsFixed(2)}!',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          
          _buildSummaryRow('Subtotal (${cart.itemCount} items)', '\$${cart.subtotal.toStringAsFixed(2)}'),
          AppSpacing.verticalGapMd,
          _buildSummaryRow(
            'Shipping',
            cart.shippingCost == 0 ? 'FREE' : '\$${cart.shippingCost.toStringAsFixed(2)}',
            isHighlight: cart.shippingCost == 0,
          ),
          AppSpacing.verticalGapMd,
          _buildSummaryRow('Estimated Tax', '\$${cart.tax.toStringAsFixed(2)}'),
          AppSpacing.verticalGapLg,
          const Divider(),
          AppSpacing.verticalGapLg,
          _buildSummaryRow(
            'Total',
            '\$${cart.total.toStringAsFixed(2)}',
            isBold: true,
            isLarge: true,
          ),
          AppSpacing.verticalGapXxl,
          
          // Checkout button
          AppButton(
            text: 'Proceed to Checkout',
            icon: Icons.lock_outline,
            onPressed: onCheckout,
          ),
          AppSpacing.verticalGapMd,
          
          // Continue shopping
          Center(
            child: TextButton(
              onPressed: onContinueShopping,
              child: const Text('Continue Shopping'),
            ),
          ),
          
          AppSpacing.verticalGapLg,
          
          // Free shipping notice
          if (cart.subtotal < 50)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, color: AppColors.info, size: 20),
                  AppSpacing.horizontalGapMd,
                  Expanded(
                    child: Text(
                      'Add \$${(50 - cart.subtotal).toStringAsFixed(2)} more for FREE shipping!',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isHighlight = false, bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? (isLarge ? AppTypography.titleLarge : AppTypography.titleMedium)
              : AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isBold
              ? (isLarge ? AppTypography.priceLarge : AppTypography.titleMedium)
              : AppTypography.bodyMedium.copyWith(
                  color: isHighlight ? AppColors.success : AppColors.textPrimary,
                  fontWeight: isHighlight ? FontWeight.w600 : null,
                ),
        ),
      ],
    );
  }

  void _confirmRemove(BuildContext context, CartProvider cart, String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cart.removeFromCart(productId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

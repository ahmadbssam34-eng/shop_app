import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  bool _isApplyingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () {
                  _showClearCartDialog(context, cart);
                },
                icon: const Icon(Icons.delete_outline, size: 20),
                label: const Text('إفراغ'),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // قائمة المنتجات
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _buildCartItem(context, cart, item, index);
                  },
                ),
              ),

              // قسم كود الخصم
              _buildCouponSection(cart),

              // ملخص السلة
              _buildCartSummary(cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: AppColors.neutral300,
          ),
          const SizedBox(height: AppConstants.space24),
          Text(
            'سلتك فارغة',
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppConstants.space8),
          Text(
            'ابدأ التسوق الآن واكتشف عروضنا!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.space32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('تصفح المنتجات'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartProvider cart,
    item,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.space16),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space12),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.neutral100,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.space12),

            // معلومات المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.space4),
                  if (item.selectedColor != null || item.selectedSize != null)
                    Text(
                      [
                        if (item.selectedColor != null) item.selectedColor,
                        if (item.selectedSize != null) item.selectedSize,
                      ].join(' • '),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  const SizedBox(height: AppConstants.space8),

                  // السعر والكمية
                  Row(
                    children: [
                      Text(
                        '${item.product.price.toStringAsFixed(0)} ر.س',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),

                      // أزرار التحكم بالكمية
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutral300),
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (item.quantity > 1) {
                                  cart.updateQuantity(
                                    item.product.id,
                                    item.quantity - 1,
                                  );
                                }
                              },
                              icon: const Icon(Icons.remove, size: 18),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Text(
                              '${item.quantity}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (item.quantity < item.product.stock) {
                                  cart.updateQuantity(
                                    item.product.id,
                                    item.quantity + 1,
                                  );
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.space8),

                  // زر الحذف
                  TextButton.icon(
                    onPressed: () {
                      cart.removeFromCart(item.product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم حذف المنتج من السلة'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('حذف'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error500,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎟️ لديك كود خصم؟', style: AppTypography.bodyLarge),
          const SizedBox(height: AppConstants.space12),

          if (cart.cart.appliedCouponCode != null)
            // كود مطبق
            Container(
              padding: const EdgeInsets.all(AppConstants.space12),
              decoration: BoxDecoration(
                color: AppColors.accent500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.accent500),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.accent500),
                  const SizedBox(width: AppConstants.space8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تم تطبيق الكود: ${cart.cart.appliedCouponCode}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.accent500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'وفّرت ${cart.cart.discount.toStringAsFixed(0)} ر.س',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cart.removeCoupon();
                    },
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.accent500,
                  ),
                ],
              ),
            )
          else
            // حقل إدخال الكود
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: 'أدخل الكود',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusMedium),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.space16,
                        vertical: AppConstants.space12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.space12),
                ElevatedButton(
                  onPressed: _isApplyingCoupon
                      ? null
                      : () async {
                          if (_couponController.text.isEmpty) return;

                          setState(() {
                            _isApplyingCoupon = true;
                          });

                          await Future.delayed(const Duration(seconds: 1));

                          final success =
                              cart.applyCoupon(_couponController.text);

                          setState(() {
                            _isApplyingCoupon = false;
                          });

                          if (success) {
                            _couponController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ تم تطبيق الكود بنجاح!'),
                                backgroundColor: AppColors.accent500,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '❌ الكود غير صالح أو منتهي الصلاحية'),
                                backgroundColor: AppColors.error500,
                              ),
                            );
                          }
                        },
                  child: _isApplyingCoupon
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('تطبيق'),
                ),
              ],
            ),

          // أكواد خصم مقترحة
          if (cart.cart.appliedCouponCode == null) ...[
            const SizedBox(height: AppConstants.space12),
            Wrap(
              spacing: 8,
              children: [
                _buildCouponChip('SUMMER20', '20% خصم'),
                _buildCouponChip('SAVE50', '50 ر.س خصم'),
                _buildCouponChip('WELCOME', '10% خصم'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCouponChip(String code, String description) {
    return ActionChip(
      label: Text('$code - $description'),
      labelStyle: AppTypography.bodySmall,
      onPressed: () {
        _couponController.text = code;
      },
    );
  }

  Widget _buildCartSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'المجموع الفرعي',
            '${cart.cart.subtotal.toStringAsFixed(2)} ر.س',
          ),
          if (cart.cart.discount > 0)
            _buildSummaryRow(
              'الخصم (${cart.cart.appliedCouponCode})',
              '-${cart.cart.discount.toStringAsFixed(2)} ر.س',
              color: AppColors.accent500,
            ),
          _buildSummaryRow(
            'التوصيل',
            cart.cart.shipping == 0
                ? 'مجاني'
                : '${cart.cart.shipping.toStringAsFixed(2)} ر.س',
            color: cart.cart.shipping == 0 ? AppColors.accent500 : null,
          ),
          const Divider(height: AppConstants.space24),
          _buildSummaryRow(
            'الإجمالي',
            '${cart.cart.total.toStringAsFixed(2)} ر.س',
            isTotal: true,
          ),

          if (cart.cart.savedAmount > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.space8),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.space8),
                decoration: BoxDecoration(
                  color: AppColors.accent500.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  '💰 وفّرت ${cart.cart.savedAmount.toStringAsFixed(0)} ر.س!',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.accent500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppConstants.space16),

          // أزرار
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('متابعة التسوق'),
                ),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary500.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: الانتقال لصفحة الدفع
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🚀 سيتم الانتقال لصفحة الدفع قريباً'),
                          backgroundColor: AppColors.primary600,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text('إتمام الشراء'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {Color? color, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.h4
                : AppTypography.bodyMedium.copyWith(color: color),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.h3.copyWith(color: AppColors.primary600)
                : AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إفراغ السلة'),
        content: const Text('هل أنت متأكد من حذف جميع المنتجات من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إفراغ السلة'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
            ),
            child: const Text('إفراغ'),
          ),
        ],
      ),
    );
  }
}

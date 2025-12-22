import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final allImages = [widget.product.imageUrl, ...widget.product.additionalImages];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // معرض الصور
                  PageView.builder(
                    itemCount: allImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: allImages[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.neutral100,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    },
                  ),

                  // مؤشر الصور
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        allImages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? AppColors.error500 : null,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: مشاركة المنتج
                },
              ),
            ],
          ),

          // محتوى الصفحة
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المنتج
                      Text(
                        widget.product.title,
                        style: AppTypography.h2,
                      ),
                      const SizedBox(height: AppConstants.space12),

                      // التقييم
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < widget.product.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.warning500,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.product.rating}',
                            style: AppTypography.bodyMedium
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${widget.product.reviewCount} تقييم)',
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.neutral400),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.space16),

                      // السعر
                      Row(
                        children: [
                          Text(
                            '${widget.product.price.toStringAsFixed(0)} ر.س',
                            style: AppTypography.h2
                                .copyWith(color: AppColors.primary600),
                          ),
                          if (widget.product.hasDiscount) ...[
                            const SizedBox(width: 12),
                            Text(
                              '${widget.product.originalPrice!.toStringAsFixed(0)} ر.س',
                              style: AppTypography.bodyLarge.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.neutral400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${widget.product.discountPercentage}%',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppConstants.space16),

                      // مؤشر المخزون
                      if (widget.product.isLowStock)
                        Container(
                          padding: const EdgeInsets.all(AppConstants.space12),
                          decoration: BoxDecoration(
                            color: AppColors.warning500.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                color: AppColors.warning500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '⚠️ باقي ${widget.product.stock} قطع فقط - اطلب الآن!',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.warning500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: AppConstants.space24),

                      // معلومات التوصيل والإرجاع
                      _buildInfoTile(
                        Icons.local_shipping_outlined,
                        'التوصيل',
                        'خلال 2-3 أيام عمل',
                      ),
                      _buildInfoTile(
                        Icons.cached,
                        'الإرجاع',
                        'إرجاع مجاني خلال 14 يوم',
                      ),
                      _buildInfoTile(
                        Icons.verified_user_outlined,
                        'الضمان',
                        'ضمان سنتين من الوكيل',
                      ),
                      const SizedBox(height: AppConstants.space24),

                      const Divider(),
                      const SizedBox(height: AppConstants.space24),

                      // الكمية
                      Text('🔢 الكمية', style: AppTypography.h4),
                      const SizedBox(height: AppConstants.space12),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1
                                ? () {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.neutral200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.space24),
                            child: Text(
                              '$_quantity',
                              style: AppTypography.h3,
                            ),
                          ),
                          IconButton(
                            onPressed: _quantity < widget.product.stock
                                ? () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.space24),

                      const Divider(),
                      const SizedBox(height: AppConstants.space24),

                      // الوصف
                      Text('📄 الوصف', style: AppTypography.h4),
                      const SizedBox(height: AppConstants.space12),
                      Text(
                        widget.product.description,
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppConstants.space24),

                      const Divider(),
                      const SizedBox(height: AppConstants.space24),

                      // آراء العملاء
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('💬 آراء العملاء', style: AppTypography.h4),
                          TextButton(
                            onPressed: () {
                              // TODO: عرض جميع التقييمات
                            },
                            child: const Text('عرض الكل'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.space16),

                      // نموذج تقييم
                      _buildReviewCard(),

                      const SizedBox(height: AppConstants.space48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // شريط الأزرار السفلي
      bottomNavigationBar: Container(
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  for (int i = 0; i < _quantity; i++) {
                    cart.addToCart(widget.product);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ تمت الإضافة إلى السلة'),
                      backgroundColor: AppColors.accent500,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('أضف للسلة'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.space12),
            Expanded(
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
                    for (int i = 0; i < _quantity; i++) {
                      cart.addToCart(widget.product);
                    }
                    Navigator.pushNamed(context, '/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('اشترِ الآن'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.space12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary600),
          const SizedBox(width: AppConstants.space12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodySmall),
              Text(
                subtitle,
                style: AppTypography.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary100,
                  child: Icon(Icons.person, color: AppColors.primary600),
                ),
                const SizedBox(width: AppConstants.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('أحمد محمد', style: AppTypography.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent500,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '✓ مشترٍ موثق',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'منذ يومين',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.neutral400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space12),
            Row(
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: AppColors.warning500,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space8),
            Text(
              'منتج ممتاز! الجودة عالية والتوصيل كان سريع. أنصح بشدة بالشراء',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppConstants.space12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_outlined, size: 16),
                  label: const Text('45'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                ),
                const SizedBox(width: AppConstants.space12),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 16),
                  label: const Text('رد'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

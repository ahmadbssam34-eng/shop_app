import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product.dart';
import '../../../data/models/review.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/price_tag.dart';
import '../../widgets/common/rating_stars.dart';
import '../../widgets/common/badge_widget.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/product_card.dart';

/// Product detail screen with gallery, options, and related products
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final VoidCallback? onBack;
  final ValueChanged<Product>? onProductTap;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.onBack,
    this.onProductTap,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _pageController = PageController();
  int _quantity = 1;
  String? _selectedColor;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final product = productProvider.getProductById(widget.productId);
        
        if (product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.textTertiary),
                AppSpacing.verticalGapLg,
                Text('Product not found', style: AppTypography.titleMedium),
              ],
            ),
          );
        }

        // Initialize selected color
        _selectedColor ??= product.colors?.first;

        final relatedProducts = productProvider.getRelatedProducts(product.id);

        return Scaffold(
          body: isWide
              ? _buildDesktopLayout(product, relatedProducts)
              : _buildMobileLayout(product, relatedProducts),
          bottomNavigationBar: isWide ? null : _buildMobileBottomBar(product),
        );
      },
    );
  }

  Widget _buildMobileLayout(Product product, List<Product> relatedProducts) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          ],
        ),
        
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Gallery
              _buildImageGallery(product),
              
              Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.verticalGapLg,
                    
                    // Badges
                    _buildBadges(product),
                    AppSpacing.verticalGapMd,
                    
                    // Title
                    Text(product.name, style: AppTypography.headlineSmall),
                    AppSpacing.verticalGapSm,
                    
                    // Brand
                    if (product.brand != null)
                      Text(
                        product.brand!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    AppSpacing.verticalGapMd,
                    
                    // Rating
                    RatingStars(
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                    ),
                    AppSpacing.verticalGapLg,
                    
                    // Price
                    PriceTag(
                      price: product.price,
                      originalPrice: product.originalPrice,
                      isLarge: true,
                    ),
                    AppSpacing.verticalGapXxl,
                    
                    // Color Options
                    if (product.colors != null && product.colors!.isNotEmpty)
                      _buildColorOptions(product),
                    
                    AppSpacing.verticalGapXxl,
                    
                    // Tabs
                    _buildTabs(product),
                  ],
                ),
              ),
              
              AppSpacing.verticalGapXxl,
              
              // Related Products
              if (relatedProducts.isNotEmpty) _buildRelatedProducts(relatedProducts),
              
              AppSpacing.verticalGapXxxl,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Product product, List<Product> relatedProducts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.onBack ?? () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Shop'),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxxl),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left - Images
                Expanded(
                  flex: 1,
                  child: _buildImageGallery(product),
                ),
                AppSpacing.horizontalGapXxxl,
                // Right - Details
                Expanded(
                  flex: 1,
                  child: _buildProductDetails(product),
                ),
              ],
            ),
          ),
          
          AppSpacing.verticalGapXxxl,
          
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxxl),
            child: _buildTabs(product),
          ),
          
          AppSpacing.verticalGapXxxl,
          
          // Related Products
          if (relatedProducts.isNotEmpty) _buildRelatedProducts(relatedProducts),
          
          AppSpacing.verticalGapXxxl,
        ],
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    return Column(
      children: [
        // Main Image
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: product.images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image_not_supported),
                ),
              );
            },
          ),
        ),
        AppSpacing.verticalGapMd,
        // Page Indicator
        SmoothPageIndicator(
          controller: _pageController,
          count: product.images.length,
          effect: WormEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.border,
          ),
        ),
        AppSpacing.verticalGapMd,
        // Thumbnail Strip
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalLg,
            itemCount: product.images.length,
            separatorBuilder: (_, __) => AppSpacing.horizontalGapSm,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(
                      color: _currentImageIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: AppSpacing.borderRadiusSm,
                    child: CachedNetworkImage(
                      imageUrl: product.images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges
        _buildBadges(product),
        AppSpacing.verticalGapMd,
        
        // Title
        Text(product.name, style: AppTypography.headlineMedium),
        AppSpacing.verticalGapSm,
        
        // Brand
        if (product.brand != null)
          Text(
            product.brand!,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        AppSpacing.verticalGapMd,
        
        // Rating
        RatingStars(rating: product.rating, reviewCount: product.reviewCount),
        AppSpacing.verticalGapXxl,
        
        // Price
        PriceTag(
          price: product.price,
          originalPrice: product.originalPrice,
          isLarge: true,
        ),
        AppSpacing.verticalGapXxxl,
        
        // Color Options
        if (product.colors != null && product.colors!.isNotEmpty)
          _buildColorOptions(product),
        
        AppSpacing.verticalGapXxl,
        
        // Quantity
        _buildQuantitySelector(),
        AppSpacing.verticalGapXxl,
        
        // Add to Cart Button
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Add to Cart',
                icon: Icons.shopping_cart,
                onPressed: () => _addToCart(product),
              ),
            ),
            AppSpacing.horizontalGapMd,
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGapXxl,
        
        // Stock Status
        Row(
          children: [
            Icon(
              product.inStock ? Icons.check_circle : Icons.cancel,
              size: 18,
              color: product.inStock ? AppColors.success : AppColors.error,
            ),
            AppSpacing.horizontalGapSm,
            Text(
              product.inStock ? 'In Stock' : 'Out of Stock',
              style: AppTypography.bodyMedium.copyWith(
                color: product.inStock ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadges(Product product) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        if (product.hasDiscount)
          BadgeWidget.sale('-${product.discountPercentage}%'),
        if (product.isNew) BadgeWidget.newItem(),
        if (product.isFeatured) BadgeWidget.featured(),
      ],
    );
  }

  Widget _buildColorOptions(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color: $_selectedColor',
          style: AppTypography.titleSmall,
        ),
        AppSpacing.verticalGapMd,
        Wrap(
          spacing: AppSpacing.sm,
          children: product.colors!.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                  borderRadius: AppSpacing.borderRadiusSm,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  color,
                  style: AppTypography.labelLarge.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantity', style: AppTypography.titleSmall),
        AppSpacing.verticalGapMd,
        Container(
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  _quantity.toString(),
                  style: AppTypography.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(Product product) {
    final reviews = DemoReviews.getByProductId(product.id);
    
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Specifications'),
            Tab(text: 'Shipping'),
            Tab(text: 'Reviews'),
          ],
        ),
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Description
              Padding(
                padding: AppSpacing.paddingLg,
                child: Text(
                  product.description,
                  style: AppTypography.bodyLarge,
                ),
              ),
              // Specifications
              Padding(
                padding: AppSpacing.paddingLg,
                child: product.specifications != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.specifications!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    entry.key,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.toString(),
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : const Text('No specifications available'),
              ),
              // Shipping
              Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShippingItem(
                      Icons.local_shipping_outlined,
                      'Free Standard Shipping',
                      'Orders over \$50 ship free. 5-7 business days.',
                    ),
                    AppSpacing.verticalGapMd,
                    _buildShippingItem(
                      Icons.rocket_launch_outlined,
                      'Express Shipping',
                      '\$9.99 - 2-3 business days.',
                    ),
                    AppSpacing.verticalGapMd,
                    _buildShippingItem(
                      Icons.replay_outlined,
                      '30-Day Returns',
                      'Easy returns within 30 days of purchase.',
                    ),
                  ],
                ),
              ),
              // Reviews
              ListView.separated(
                padding: AppSpacing.paddingLg,
                itemCount: reviews.isEmpty ? 1 : reviews.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  if (reviews.isEmpty) {
                    return Center(
                      child: Text(
                        'No reviews yet',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    );
                  }
                  final review = reviews[index];
                  return _buildReviewItem(review);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        AppSpacing.horizontalGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall),
              AppSpacing.verticalGapXs,
              Text(
                description,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                review.userName[0],
                style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
              ),
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.userName, style: AppTypography.titleSmall),
                  RatingStars(rating: review.rating, showText: false, size: 14),
                ],
              ),
            ),
            if (review.isVerifiedPurchase)
              BadgeWidget(
                text: 'Verified',
                backgroundColor: AppColors.successLight,
                textColor: AppColors.success,
                isSmall: true,
              ),
          ],
        ),
        AppSpacing.verticalGapMd,
        Text(review.comment, style: AppTypography.bodyMedium),
      ],
    );
  }

  Widget _buildRelatedProducts(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Text('Related Products', style: AppTypography.headlineSmall),
        ),
        AppSpacing.verticalGapLg,
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalLg,
            itemCount: products.length,
            separatorBuilder: (_, __) => AppSpacing.horizontalGapMd,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: ProductCard(
                  product: products[index],
                  isCompact: true,
                  showAddToCart: false,
                  onTap: () => widget.onProductTap?.call(products[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBottomBar(Product product) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
        child: Row(
          children: [
            // Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTypography.priceLarge,
                ),
                if (product.hasDiscount)
                  Text(
                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                    style: AppTypography.priceOriginal,
                  ),
              ],
            ),
            AppSpacing.horizontalGapXxl,
            // Add to Cart
            Expanded(
              child: AppButton(
                text: 'Add to Cart',
                icon: Icons.shopping_cart,
                onPressed: () => _addToCart(product),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    context.read<CartProvider>().addToCart(
      product,
      quantity: _quantity,
      color: _selectedColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }
}

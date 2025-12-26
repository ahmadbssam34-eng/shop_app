import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/models/product.dart';
import '../../widgets/home/hero_section.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/featured_products_section.dart';
import '../../widgets/home/trust_badges_section.dart';
import '../../widgets/home/testimonials_section.dart';
import '../../widgets/home/newsletter_section.dart';
import '../../widgets/home/footer_section.dart';

/// Home screen with all sections
class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToShop;
  final VoidCallback? onNavigateToCategory;
  final ValueChanged<Product>? onProductTap;

  const HomeScreen({
    super.key,
    this.onNavigateToShop,
    this.onNavigateToCategory,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => productProvider.refreshProducts(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.verticalGapLg,
                
                // Hero Section
                HeroSection(
                  onShopNow: onNavigateToShop,
                ),
                
                AppSpacing.verticalGapXxxxl,
                
                // Category Section
                CategorySection(
                  categories: productProvider.categories,
                  onCategoryTap: (category) {
                    productProvider.setCategory(category.id);
                    onNavigateToCategory?.call();
                  },
                ),
                
                AppSpacing.verticalGapXxxxl,
                
                // Featured Products
                FeaturedProductsSection(
                  products: productProvider.featuredProducts.take(4).toList(),
                  title: 'Featured Products',
                  subtitle: 'Our top picks for you',
                  onViewAll: onNavigateToShop,
                  onProductTap: onProductTap,
                  onAddToCart: (product) => _addToCart(context, product),
                ),
                
                AppSpacing.verticalGapXxxxl,
                
                // Trust Badges
                const TrustBadgesSection(),
                
                AppSpacing.verticalGapXxxxl,
                
                // New Arrivals
                HorizontalProductsSection(
                  products: productProvider.newProducts,
                  title: 'New Arrivals',
                  subtitle: 'Fresh off the shelf',
                  onViewAll: onNavigateToShop,
                  onProductTap: onProductTap,
                  onAddToCart: (product) => _addToCart(context, product),
                ),
                
                AppSpacing.verticalGapXxxxl,
                
                // Testimonials
                const TestimonialsSection(),
                
                AppSpacing.verticalGapXxxxl,
                
                // Newsletter
                const NewsletterSection(),
                
                AppSpacing.verticalGapXxxxl,
                
                // Footer
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<CartProvider>().addToCart(product);
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

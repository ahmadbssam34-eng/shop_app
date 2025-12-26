import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/models/product.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/home/category_section.dart';

/// Shop / Products listing screen
class ShopScreen extends StatefulWidget {
  final ValueChanged<Product>? onProductTap;

  const ShopScreen({super.key, this.onProductTap});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return Column(
          children: [
            // Search and Filter Bar
            _buildSearchBar(productProvider),
            
            // Category Chips
            CategoryChips(
              categories: productProvider.categories,
              selectedCategoryId: productProvider.selectedCategory,
              onSelected: (categoryId) => productProvider.setCategory(categoryId),
            ),
            AppSpacing.verticalGapMd,
            
            // Results count and sort
            _buildResultsBar(productProvider),
            
            // Products Grid
            Expanded(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Side Filters (Desktop)
                        SizedBox(
                          width: 280,
                          child: _buildFiltersPanel(productProvider),
                        ),
                        // Products
                        Expanded(child: _buildProductsGrid(productProvider)),
                      ],
                    )
                  : _showFilters
                      ? _buildFiltersPanel(productProvider)
                      : _buildProductsGrid(productProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: SearchTextField(
              controller: _searchController,
              hint: 'Search products...',
              onChanged: (value) => provider.setSearchQuery(value),
              onClear: () => provider.setSearchQuery(''),
            ),
          ),
          AppSpacing.horizontalGapMd,
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              icon: Icon(
                _showFilters ? Icons.filter_list_off : Icons.filter_list,
                color: _showFilters ? AppColors.primary : AppColors.textPrimary,
              ),
              onPressed: () => setState(() => _showFilters = !_showFilters),
              tooltip: 'Filters',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsBar(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${provider.products.length} products found',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          DropdownButton<String>(
            value: provider.sortBy,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            style: AppTypography.labelLarge,
            items: const [
              DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
              DropdownMenuItem(value: 'newest', child: Text('Newest')),
              DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
              DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
              DropdownMenuItem(value: 'rating', child: Text('Top Rated')),
            ],
            onChanged: (value) {
              if (value != null) provider.setSortBy(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel(ProductProvider provider) {
    final priceRange = provider.priceRange;
    
    return Container(
      padding: AppSpacing.cardPadding,
      margin: const EdgeInsets.only(left: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: AppTypography.titleMedium),
                TextButton(
                  onPressed: () => provider.clearFilters(),
                  child: const Text('Clear All'),
                ),
              ],
            ),
            AppSpacing.verticalGapLg,
            
            // Price Range
            Text('Price Range', style: AppTypography.titleSmall),
            AppSpacing.verticalGapMd,
            RangeSlider(
              values: RangeValues(
                provider.minPrice ?? priceRange.$1,
                provider.maxPrice ?? priceRange.$2,
              ),
              min: priceRange.$1,
              max: priceRange.$2,
              divisions: 20,
              labels: RangeLabels(
                '\$${(provider.minPrice ?? priceRange.$1).toStringAsFixed(0)}',
                '\$${(provider.maxPrice ?? priceRange.$2).toStringAsFixed(0)}',
              ),
              onChanged: (values) {
                provider.setPriceRange(values.start, values.end);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${(provider.minPrice ?? priceRange.$1).toStringAsFixed(0)}',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  '\$${(provider.maxPrice ?? priceRange.$2).toStringAsFixed(0)}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            
            AppSpacing.verticalGapXxl,
            
            // Rating Filter
            Text('Minimum Rating', style: AppTypography.titleSmall),
            AppSpacing.verticalGapMd,
            ...[4.0, 3.0, 2.0].map((rating) {
              return RadioListTile<double>(
                value: rating,
                groupValue: provider.minRating,
                onChanged: (value) => provider.setMinRating(value),
                title: Row(
                  children: [
                    ...List.generate(rating.toInt(), (_) {
                      return const Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.rating,
                      );
                    }),
                    AppSpacing.horizontalGapXs,
                    Text('& up', style: AppTypography.bodySmall),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }),
            
            AppSpacing.verticalGapLg,
            
            // Apply Button (Mobile)
            if (MediaQuery.of(context).size.width <= AppSpacing.tabletBreakpoint)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showFilters = false),
                  child: const Text('Apply Filters'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(ProductProvider provider) {
    if (provider.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalGapLg,
            Text(
              'No products found',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalGapSm,
            Text(
              'Try adjusting your filters',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.verticalGapXxl,
            OutlinedButton(
              onPressed: () => provider.clearFilters(),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth > AppSpacing.desktopBreakpoint) {
      crossAxisCount = 3;
      childAspectRatio = 0.65;
    } else if (screenWidth > AppSpacing.tabletBreakpoint) {
      crossAxisCount = 2;
      childAspectRatio = 0.65;
    } else if (screenWidth > AppSpacing.mobileBreakpoint) {
      crossAxisCount = 2;
      childAspectRatio = 0.62;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.58;
    }

    return GridView.builder(
      padding: AppSpacing.paddingLg,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return ProductCard(
          product: product,
          onTap: () => widget.onProductTap?.call(product),
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  void _addToCart(Product product) {
    context.read<CartProvider>().addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

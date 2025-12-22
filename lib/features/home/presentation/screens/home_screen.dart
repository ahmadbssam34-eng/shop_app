import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/dummy_data.dart';
import '../../../../data/providers/cart_provider.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentHeroIndex = 0;
  String _selectedCategory = 'الكل';

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'الكل') {
      return DummyData.products;
    }
    return DummyData.products
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: AppColors.primary600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppConstants.appName,
              style: AppTypography.h3.copyWith(
                color: AppColors.primary600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: الإشعارات
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error500,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط البحث
            Padding(
              padding: const EdgeInsets.all(AppConstants.space16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتجات...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // TODO: البحث الصوتي
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.neutral100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () {
                  // TODO: فتح صفحة البحث
                },
                readOnly: true,
              ),
            ),

            // Hero Carousel - الخلفية الديناميكية
            _buildHeroCarousel(),

            const SizedBox(height: AppConstants.space24),

            // التصنيفات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
              child: Text('🔥 التصنيفات', style: AppTypography.h2),
            ),
            const SizedBox(height: AppConstants.space16),
            _buildCategoriesChips(),

            const SizedBox(height: AppConstants.space24),

            // الأكثر مبيعاً
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('⭐ الأكثر مبيعاً', style: AppTypography.h2),
                  TextButton(
                    onPressed: () {
                      // TODO: عرض الكل
                    },
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space16),

            // شبكة المنتجات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: AppConstants.space16,
                  mainAxisSpacing: AppConstants.space16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    onAddToCart: () {
                      cart.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('✅ تمت الإضافة إلى السلة'),
                          backgroundColor: AppColors.accent500,
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'عرض السلة',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.space48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: DummyData.heroImages.length,
          options: CarouselOptions(
            height: 240,
            autoPlay: true,
            autoPlayInterval: AppConstants.heroAutoPlayInterval,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentHeroIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Stack(
              children: [
                // الصورة
                CachedNetworkImage(
                  imageUrl: DummyData.heroImages[index],
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.neutral100,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),

                // Gradient Overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                  ),
                ),

                // النص
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DummyData.heroTexts[index]['title']!,
                        style: AppTypography.h2.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DummyData.heroTexts[index]['subtitle']!,
                        style: AppTypography.bodyMedium
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary600,
                        ),
                        child: const Text('تسوق الآن'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // المؤشرات (Dots)
        AnimatedSmoothIndicator(
          activeIndex: _currentHeroIndex,
          count: DummyData.heroImages.length,
          effect: const WormEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: AppColors.primary600,
            dotColor: AppColors.neutral300,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
        itemCount: DummyData.categories.length,
        itemBuilder: (context, index) {
          final category = DummyData.categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(left: AppConstants.space12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppColors.neutral200,
              selectedColor: AppColors.primary500,
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.neutral900,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'مرحباً، عميلنا العزيز',
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                Text(
                  'user@example.com',
                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('طلباتي'),
            onTap: () {
              Navigator.pop(context);
              // TODO: صفحة الطلبات
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('المفضلة'),
            onTap: () {
              Navigator.pop(context);
              // TODO: صفحة المفضلة
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {
              Navigator.pop(context);
              // TODO: صفحة الملف الشخصي
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
              // TODO: صفحة الإعدادات
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('حول التطبيق'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error500),
            title: const Text('تسجيل الخروج',
                style: TextStyle(color: AppColors.error500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏢 ${AppConstants.companyName}',
                style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            Text('📜 س.ت: ${AppConstants.commercialRegister}',
                style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            Text('📋 ${AppConstants.licenseNumber}',
                style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            Text('🏠 ${AppConstants.companyAddress}',
                style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            Text('الإصدار: ${AppConstants.appVersion}',
                style: AppTypography.caption),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

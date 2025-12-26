import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/product.dart';
import '../widgets/common/app_navbar.dart';
import 'home/home_screen.dart';
import 'shop/shop_screen.dart';
import 'product/product_detail_screen.dart';
import 'cart/cart_screen.dart';
import 'checkout/checkout_screen.dart';
import 'auth/auth_screen.dart';
import 'admin/admin_screen.dart';

/// Navigation routes
enum AppRoute {
  home,
  shop,
  productDetail,
  cart,
  checkout,
  auth,
  admin,
}

/// Main app shell with navigation
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppRoute _currentRoute = AppRoute.home;
  int _bottomNavIndex = 0;
  String? _selectedProductId;
  
  // Navigation history stack for back navigation
  final List<AppRoute> _routeHistory = [AppRoute.home];

  void _navigateTo(AppRoute route, {String? productId}) {
    setState(() {
      _currentRoute = route;
      _selectedProductId = productId;
      
      // Update bottom nav index
      switch (route) {
        case AppRoute.home:
          _bottomNavIndex = 0;
          break;
        case AppRoute.shop:
          _bottomNavIndex = 1;
          break;
        case AppRoute.cart:
          _bottomNavIndex = 2;
          break;
        case AppRoute.auth:
          _bottomNavIndex = 3;
          break;
        default:
          break;
      }
      
      // Add to history (avoid duplicates)
      if (_routeHistory.isEmpty || _routeHistory.last != route) {
        _routeHistory.add(route);
      }
    });
  }

  void _goBack() {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      setState(() {
        _currentRoute = _routeHistory.last;
      });
    } else {
      _navigateTo(AppRoute.home);
    }
  }

  void _onProductTap(Product product) {
    _navigateTo(AppRoute.productDetail, productId: product.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showBottomNav = screenWidth <= AppSpacing.tabletBreakpoint;
    
    // Full screen routes (no shell)
    if (_currentRoute == AppRoute.auth ||
        _currentRoute == AppRoute.checkout ||
        _currentRoute == AppRoute.admin) {
      return _buildFullScreenRoute();
    }

    return Scaffold(
      appBar: AppNavbar(
        onLogoTap: () => _navigateTo(AppRoute.home),
        onSearchTap: () => _navigateTo(AppRoute.shop),
        onCategoryTap: () => _navigateTo(AppRoute.shop),
        onAccountTap: () => _navigateTo(AppRoute.auth),
        onCartTap: () => _navigateTo(AppRoute.cart),
      ),
      body: _buildBody(),
      bottomNavigationBar: showBottomNav
          ? AppBottomNavBar(
              currentIndex: _bottomNavIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    _navigateTo(AppRoute.home);
                    break;
                  case 1:
                    _navigateTo(AppRoute.shop);
                    break;
                  case 2:
                    _navigateTo(AppRoute.cart);
                    break;
                  case 3:
                    _navigateTo(AppRoute.auth);
                    break;
                }
              },
            )
          : null,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBody() {
    switch (_currentRoute) {
      case AppRoute.home:
        return HomeScreen(
          onNavigateToShop: () => _navigateTo(AppRoute.shop),
          onNavigateToCategory: () => _navigateTo(AppRoute.shop),
          onProductTap: _onProductTap,
        );
      case AppRoute.shop:
        return ShopScreen(
          onProductTap: _onProductTap,
        );
      case AppRoute.productDetail:
        return ProductDetailScreen(
          productId: _selectedProductId ?? '',
          onBack: _goBack,
          onProductTap: _onProductTap,
        );
      case AppRoute.cart:
        return CartScreen(
          onCheckout: () => _navigateTo(AppRoute.checkout),
          onContinueShopping: () => _navigateTo(AppRoute.shop),
        );
      default:
        return HomeScreen(
          onNavigateToShop: () => _navigateTo(AppRoute.shop),
          onProductTap: _onProductTap,
        );
    }
  }

  Widget _buildFullScreenRoute() {
    switch (_currentRoute) {
      case AppRoute.auth:
        return AuthScreen(
          onBack: _goBack,
          onAuthSuccess: () => _navigateTo(AppRoute.home),
        );
      case AppRoute.checkout:
        return CheckoutScreen(
          onBack: _goBack,
          onOrderComplete: () => _navigateTo(AppRoute.home),
        );
      case AppRoute.admin:
        return AdminScreen(
          onBack: _goBack,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget? _buildFAB() {
    // Show admin FAB only on desktop/tablet
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= AppSpacing.tabletBreakpoint) return null;
    if (_currentRoute == AppRoute.productDetail) return null;

    return FloatingActionButton.extended(
      onPressed: () => _navigateTo(AppRoute.admin),
      icon: const Icon(Icons.admin_panel_settings),
      label: const Text('Admin'),
    );
  }
}

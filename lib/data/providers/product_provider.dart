import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart' as app_category;
import '../repositories/demo_data.dart';

/// Product Provider for state management
class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  String _sortBy = 'popular';
  String _searchQuery = '';
  bool _isLoading = false;

  /// Initialize with demo data
  ProductProvider() {
    _loadProducts();
  }

  /// Load products (simulates API call)
  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    _products = DemoData.products;
    _filteredProducts = _products;
    _isLoading = false;
    notifyListeners();
  }

  /// Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;
  String get searchQuery => _searchQuery;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  double? get minRating => _minRating;

  /// Get featured products
  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  /// Get new products
  List<Product> get newProducts =>
      _products.where((p) => p.isNew).toList();

  /// Get all categories
  List<app_category.Category> get categories => app_category.AppCategories.all;

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get products by category
  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.category == categoryId).toList();
  }

  /// Get related products
  List<Product> getRelatedProducts(String productId, {int limit = 4}) {
    final product = getProductById(productId);
    if (product == null) return [];

    return _products
        .where((p) => p.id != productId && p.category == product.category)
        .take(limit)
        .toList();
  }

  /// Set category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Set price range
  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  /// Set minimum rating
  void setMinRating(double? rating) {
    _minRating = rating;
    _applyFilters();
  }

  /// Set sort option
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _minRating = null;
    _sortBy = 'popular';
    _searchQuery = '';
    _filteredProducts = _products;
    notifyListeners();
  }

  /// Apply all filters
  void _applyFilters() {
    _filteredProducts = DemoData.getFiltered(
      category: _selectedCategory,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
      sortBy: _sortBy,
    );

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      _filteredProducts = _filteredProducts.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        p.description.toLowerCase().contains(lowerQuery) ||
        (p.brand?.toLowerCase().contains(lowerQuery) ?? false)
      ).toList();
    }

    notifyListeners();
  }

  /// Refresh products
  Future<void> refreshProducts() async {
    await _loadProducts();
    _applyFilters();
  }

  /// Get price range for filter
  (double, double) get priceRange {
    if (_products.isEmpty) return (0, 100);
    final prices = _products.map((p) => p.price).toList();
    return (prices.reduce((a, b) => a < b ? a : b), prices.reduce((a, b) => a > b ? a : b));
  }
}

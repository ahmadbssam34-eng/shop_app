import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/demo_data.dart';

/// Admin Provider for product management
class AdminProvider extends ChangeNotifier {
  List<Product> _products = [];
  Product? _editingProduct;
  bool _isLoading = false;

  AdminProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    _products = List.from(DemoData.products);
    notifyListeners();
  }

  /// Getters
  List<Product> get products => _products;
  Product? get editingProduct => _editingProduct;
  bool get isLoading => _isLoading;

  /// Set product for editing
  void setEditingProduct(Product? product) {
    _editingProduct = product;
    notifyListeners();
  }

  /// Add new product
  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _products.add(product);
    _isLoading = false;
    notifyListeners();
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }

    _editingProduct = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _products.removeWhere((p) => p.id == productId);
    _isLoading = false;
    notifyListeners();
  }

  /// Generate new product ID
  String generateProductId() {
    return 'p${DateTime.now().millisecondsSinceEpoch}';
  }
}

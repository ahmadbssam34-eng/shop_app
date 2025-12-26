import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Cart Provider for state management
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Get all cart items
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get total number of items
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total unique products
  int get uniqueItemCount => _items.length;

  /// Get subtotal
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Get total original price (for savings calculation)
  double get totalOriginalPrice => _items.fold(0, (sum, item) {
    if (item.product.originalPrice != null) {
      return sum + (item.product.originalPrice! * item.quantity);
    }
    return sum + item.totalPrice;
  });

  /// Get total savings
  double get totalSavings => totalOriginalPrice - subtotal;

  /// Check if cart has savings
  bool get hasSavings => totalSavings > 0;

  /// Shipping cost (free over $50)
  double get shippingCost => subtotal >= 50 ? 0 : 5.99;

  /// Tax (10%)
  double get tax => subtotal * 0.10;

  /// Grand total
  double get total => subtotal + shippingCost + tax;

  /// Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity of product in cart
  int getQuantity(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }

  /// Add product to cart
  void addToCart(Product product, {int quantity = 1, String? color, String? variant}) {
    final existingIndex = _items.indexWhere(
      (item) => 
        item.product.id == product.id &&
        item.selectedColor == color &&
        item.selectedVariant == variant,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: color,
        selectedVariant: variant,
      ));
    }
    notifyListeners();
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  /// Increment quantity
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrement quantity
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

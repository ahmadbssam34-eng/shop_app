import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedCouponCode;
  double? _couponDiscount;

  List<CartItem> get items => List.unmodifiable(_items);
  Cart get cart => Cart(
        items: _items,
        appliedCouponCode: _appliedCouponCode,
        couponDiscount: _couponDiscount,
      );

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product, {String? color, String? size}) {
    // البحث عن منتج موجود بنفس الخصائص
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      // زيادة الكمية
      _items[existingIndex].quantity++;
    } else {
      // إضافة منتج جديد
      _items.add(CartItem(
        product: product,
        selectedColor: color,
        selectedSize: size,
      ));
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _appliedCouponCode = null;
    _couponDiscount = null;
    notifyListeners();
  }

  bool applyCoupon(String code) {
    // محاكاة التحقق من كود الخصم
    final coupons = {
      'SUMMER20': 0.20, // 20% خصم
      'SAVE50': 50.0, // 50 ريال خصم
      'WELCOME': 0.10, // 10% خصم
    };

    if (coupons.containsKey(code.toUpperCase())) {
      _appliedCouponCode = code.toUpperCase();
      final discountValue = coupons[code.toUpperCase()]!;

      // إذا كان الخصم نسبة مئوية
      if (discountValue < 1) {
        _couponDiscount = cart.subtotal * discountValue;
      } else {
        // إذا كان الخصم قيمة ثابتة
        _couponDiscount = discountValue;
      }

      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCouponCode = null;
    _couponDiscount = null;
    notifyListeners();
  }
}

import 'product.dart';

/// Cart Item Model for Gadget Market
class CartItem {
  final Product product;
  int quantity;
  final String? selectedColor;
  final String? selectedVariant;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedVariant,
  });

  /// Get total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Get total original price for discount calculation
  double? get totalOriginalPrice =>
      product.originalPrice != null ? product.originalPrice! * quantity : null;

  /// Get savings amount
  double get savings {
    if (product.originalPrice == null) return 0;
    return (product.originalPrice! - product.price) * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedVariant': selectedVariant,
    };
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedColor,
    String? selectedVariant,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedVariant: selectedVariant ?? this.selectedVariant,
    );
  }
}

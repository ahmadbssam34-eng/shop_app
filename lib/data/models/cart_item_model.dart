import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedColor;
  final String? selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}

class Cart {
  final List<CartItem> items;
  String? appliedCouponCode;
  double? couponDiscount;

  Cart({
    this.items = const [],
    this.appliedCouponCode,
    this.couponDiscount,
  });

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discount {
    return couponDiscount ?? 0.0;
  }

  double get shipping {
    // توصيل مجاني فوق 200 ريال
    return subtotal >= 200 ? 0.0 : 25.0;
  }

  double get total {
    return subtotal - discount + shipping;
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  double get savedAmount {
    return items.fold(
      0.0,
      (sum, item) {
        if (item.product.hasDiscount) {
          return sum +
              ((item.product.originalPrice! - item.product.price) *
                  item.quantity);
        }
        return sum;
      },
    ) +
        discount;
  }
}

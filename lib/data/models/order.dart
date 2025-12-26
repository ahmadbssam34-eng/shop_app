import 'cart_item.dart';

/// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

/// Payment Method Enum
enum PaymentMethod {
  cashOnDelivery,
  creditCard,
  debitCard,
  upi,
}

/// Shipping Address Model
class ShippingAddress {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    this.country = 'United States',
  });

  String get fullAddress {
    final parts = [addressLine1];
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    parts.add('$city, $state $postalCode');
    parts.add(country);
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String? ?? 'United States',
    );
  }
}

/// Order Model
class Order {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final ShippingAddress shippingAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String? trackingNumber;
  final String? notes;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.subtotal,
    this.shipping = 0,
    this.tax = 0,
    this.discount = 0,
    required this.total,
    required this.createdAt,
    this.estimatedDelivery,
    this.trackingNumber,
    this.notes,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod.name,
      'status': status.name,
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'discount': discount,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'notes': notes,
    };
  }
}

import 'package:flutter/foundation.dart';
import '../models/order.dart';

/// Checkout Provider for managing checkout flow
class CheckoutProvider extends ChangeNotifier {
  int _currentStep = 0;
  ShippingAddress? _shippingAddress;
  PaymentMethod _paymentMethod = PaymentMethod.cashOnDelivery;
  String? _orderNumber;
  bool _isProcessing = false;

  /// Getters
  int get currentStep => _currentStep;
  ShippingAddress? get shippingAddress => _shippingAddress;
  PaymentMethod get paymentMethod => _paymentMethod;
  String? get orderNumber => _orderNumber;
  bool get isProcessing => _isProcessing;

  /// Check if can proceed to next step
  bool get canProceedFromAddress => _shippingAddress != null;
  bool get canProceedFromPayment => true;
  bool get canPlaceOrder => canProceedFromAddress && canProceedFromPayment;

  /// Set current step
  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Go to next step
  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Go to previous step
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Set shipping address
  void setShippingAddress(ShippingAddress address) {
    _shippingAddress = address;
    notifyListeners();
  }

  /// Set payment method
  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// Generate order number
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'GM-$random-${timestamp.toString().substring(8)}';
  }

  /// Place order (mock)
  Future<String> placeOrder() async {
    _isProcessing = true;
    notifyListeners();

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    _orderNumber = _generateOrderNumber();
    _isProcessing = false;
    notifyListeners();

    return _orderNumber!;
  }

  /// Reset checkout
  void resetCheckout() {
    _currentStep = 0;
    _shippingAddress = null;
    _paymentMethod = PaymentMethod.cashOnDelivery;
    _orderNumber = null;
    _isProcessing = false;
    notifyListeners();
  }
}

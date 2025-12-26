import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/checkout_provider.dart';
import '../../../data/models/order.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Checkout screen with stepper UI
class CheckoutScreen extends StatefulWidget {
  final VoidCallback? onOrderComplete;
  final VoidCallback? onBack;

  const CheckoutScreen({
    super.key,
    this.onOrderComplete,
    this.onBack,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CheckoutProvider, CartProvider>(
      builder: (context, checkout, cart, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
            title: const Text('Checkout'),
          ),
          body: Column(
            children: [
              // Stepper
              _buildStepper(checkout),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: _buildStepContent(checkout, cart),
                ),
              ),
              
              // Bottom buttons
              _buildBottomButtons(checkout, cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepper(CheckoutProvider checkout) {
    final steps = ['Address', 'Payment', 'Review'];
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      color: AppColors.surface,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector
            final stepIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: checkout.currentStep > stepIndex
                    ? AppColors.primary
                    : AppColors.border,
              ),
            );
          }
          // Step
          final stepIndex = index ~/ 2;
          final isActive = checkout.currentStep >= stepIndex;
          final isCurrent = checkout.currentStep == stepIndex;
          
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.border,
                width: 2,
              ),
            ),
            child: Center(
              child: isActive && !isCurrent
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '${stepIndex + 1}',
                      style: AppTypography.labelMedium.copyWith(
                        color: isActive ? Colors.white : AppColors.textTertiary,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(CheckoutProvider checkout, CartProvider cart) {
    switch (checkout.currentStep) {
      case 0:
        return _buildAddressStep(checkout);
      case 1:
        return _buildPaymentStep(checkout);
      case 2:
        return _buildReviewStep(checkout, cart);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAddressStep(CheckoutProvider checkout) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Address', style: AppTypography.headlineSmall),
          AppSpacing.verticalGapXxl,
          
          AppTextField(
            label: 'Full Name',
            controller: _fullNameController,
            hint: 'John Doe',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          AppSpacing.verticalGapLg,
          
          AppTextField(
            label: 'Phone Number',
            controller: _phoneController,
            hint: '+1 (555) 123-4567',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          AppSpacing.verticalGapLg,
          
          AppTextField(
            label: 'Address Line 1',
            controller: _addressLine1Controller,
            hint: '123 Main Street',
            prefixIcon: Icons.location_on_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          AppSpacing.verticalGapLg,
          
          AppTextField(
            label: 'Address Line 2 (Optional)',
            controller: _addressLine2Controller,
            hint: 'Apt 4B',
          ),
          AppSpacing.verticalGapLg,
          
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'City',
                  controller: _cityController,
                  hint: 'San Francisco',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: AppTextField(
                  label: 'State',
                  controller: _stateController,
                  hint: 'CA',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapLg,
          
          AppTextField(
            label: 'Postal Code',
            controller: _postalCodeController,
            hint: '94102',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter postal code';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(CheckoutProvider checkout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTypography.headlineSmall),
        AppSpacing.verticalGapXxl,
        
        // Cash on Delivery
        _buildPaymentOption(
          checkout,
          PaymentMethod.cashOnDelivery,
          Icons.money,
          'Cash on Delivery',
          'Pay when you receive your order',
        ),
        AppSpacing.verticalGapMd,
        
        // Credit Card
        _buildPaymentOption(
          checkout,
          PaymentMethod.creditCard,
          Icons.credit_card,
          'Credit Card',
          'Visa, Mastercard, American Express',
        ),
        AppSpacing.verticalGapMd,
        
        // Debit Card
        _buildPaymentOption(
          checkout,
          PaymentMethod.debitCard,
          Icons.payment,
          'Debit Card',
          'Direct debit from your bank account',
        ),
        AppSpacing.verticalGapMd,
        
        // UPI
        _buildPaymentOption(
          checkout,
          PaymentMethod.upi,
          Icons.account_balance,
          'UPI',
          'Pay using UPI apps',
        ),
        
        // Show card form if card payment selected
        if (checkout.paymentMethod == PaymentMethod.creditCard ||
            checkout.paymentMethod == PaymentMethod.debitCard) ...[
          AppSpacing.verticalGapXxl,
          _buildCardForm(),
        ],
      ],
    );
  }

  Widget _buildPaymentOption(
    CheckoutProvider checkout,
    PaymentMethod method,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = checkout.paymentMethod == method;
    
    return GestureDetector(
      onTap: () => checkout.setPaymentMethod(method),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            AppSpacing.horizontalGapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: checkout.paymentMethod,
              onChanged: (value) {
                if (value != null) checkout.setPaymentMethod(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Card Details', style: AppTypography.titleSmall),
          AppSpacing.verticalGapLg,
          
          const AppTextField(
            label: 'Card Number',
            hint: '1234 5678 9012 3456',
            prefixIcon: Icons.credit_card,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.verticalGapMd,
          
          Row(
            children: [
              const Expanded(
                child: AppTextField(
                  label: 'Expiry Date',
                  hint: 'MM/YY',
                  keyboardType: TextInputType.datetime,
                ),
              ),
              AppSpacing.horizontalGapMd,
              const Expanded(
                child: AppTextField(
                  label: 'CVV',
                  hint: '123',
                  obscureText: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          
          const AppTextField(
            label: 'Cardholder Name',
            hint: 'JOHN DOE',
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(CheckoutProvider checkout, CartProvider cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Your Order', style: AppTypography.headlineSmall),
        AppSpacing.verticalGapXxl,
        
        // Shipping Address
        _buildReviewSection(
          'Shipping Address',
          checkout.shippingAddress?.fullAddress ?? 'Not provided',
          Icons.location_on_outlined,
        ),
        AppSpacing.verticalGapLg,
        
        // Payment Method
        _buildReviewSection(
          'Payment Method',
          _getPaymentMethodText(checkout.paymentMethod),
          Icons.payment,
        ),
        AppSpacing.verticalGapLg,
        
        // Order Items
        Text('Order Items', style: AppTypography.titleMedium),
        AppSpacing.verticalGapMd,
        ...cart.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.product.name} x ${item.quantity}',
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          );
        }),
        
        AppSpacing.verticalGapLg,
        const Divider(),
        AppSpacing.verticalGapLg,
        
        // Order Summary
        _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
        AppSpacing.verticalGapSm,
        _buildSummaryRow(
          'Shipping',
          cart.shippingCost == 0 ? 'FREE' : '\$${cart.shippingCost.toStringAsFixed(2)}',
        ),
        AppSpacing.verticalGapSm,
        _buildSummaryRow('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
        AppSpacing.verticalGapMd,
        const Divider(),
        AppSpacing.verticalGapMd,
        _buildSummaryRow('Total', '\$${cart.total.toStringAsFixed(2)}', isBold: true),
      ],
    );
  }

  Widget _buildReviewSection(String title, String content, IconData icon) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          AppSpacing.horizontalGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMedium),
                AppSpacing.verticalGapXs,
                Text(content, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTypography.titleMedium : AppTypography.bodyMedium,
        ),
        Text(
          value,
          style: isBold ? AppTypography.titleMedium : AppTypography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildBottomButtons(CheckoutProvider checkout, CartProvider cart) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (checkout.currentStep > 0)
              Expanded(
                child: AppButton(
                  text: 'Back',
                  isOutlined: true,
                  onPressed: () => checkout.previousStep(),
                ),
              ),
            if (checkout.currentStep > 0) AppSpacing.horizontalGapMd,
            Expanded(
              flex: checkout.currentStep > 0 ? 2 : 1,
              child: AppButton(
                text: checkout.currentStep == 2 ? 'Place Order' : 'Continue',
                isLoading: checkout.isProcessing,
                onPressed: () => _handleNext(checkout, cart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext(CheckoutProvider checkout, CartProvider cart) async {
    if (checkout.currentStep == 0) {
      // Validate address
      if (_formKey.currentState?.validate() ?? false) {
        checkout.setShippingAddress(ShippingAddress(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          addressLine1: _addressLine1Controller.text,
          addressLine2: _addressLine2Controller.text.isEmpty 
              ? null 
              : _addressLine2Controller.text,
          city: _cityController.text,
          state: _stateController.text,
          postalCode: _postalCodeController.text,
        ));
        checkout.nextStep();
      }
    } else if (checkout.currentStep == 1) {
      checkout.nextStep();
    } else if (checkout.currentStep == 2) {
      // Place order
      final orderNumber = await checkout.placeOrder();
      cart.clearCart();
      
      if (mounted) {
        _showOrderSuccess(orderNumber);
      }
    }
  }

  void _showOrderSuccess(String orderNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.success,
                size: 48,
              ),
            ),
            AppSpacing.verticalGapXxl,
            Text('Order Placed!', style: AppTypography.headlineSmall),
            AppSpacing.verticalGapMd,
            Text(
              'Thank you for your order',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalGapXxl,
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Column(
                children: [
                  Text(
                    'Order Number',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.verticalGapSm,
                  Text(
                    orderNumber,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalGapXxl,
            Text(
              'You will receive a confirmation email with order details.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Continue Shopping',
              onPressed: () {
                Navigator.pop(context);
                context.read<CheckoutProvider>().resetCheckout();
                widget.onOrderComplete?.call();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
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
}

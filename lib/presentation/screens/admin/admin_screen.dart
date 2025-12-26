import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product.dart';
import '../../../data/models/category.dart';
import '../../../data/providers/admin_provider.dart';
import '../../../data/repositories/demo_data.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Admin panel for product management
class AdminScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AdminScreen({super.key, this.onBack});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _showForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _brandController = TextEditingController();
  String _selectedCategory = 'phone-cases';
  bool _isFeatured = false;
  bool _isNew = false;
  String? _editingId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
        title: const Text('Admin Panel'),
        actions: [
          if (!_showForm)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openForm(),
              tooltip: 'Add Product',
            ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, admin, _) {
          if (_showForm) {
            return _buildProductForm(admin);
          }
          return _buildProductList(admin);
        },
      ),
    );
  }

  Widget _buildProductList(AdminProvider admin) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppSpacing.tabletBreakpoint;

    return Column(
      children: [
        // Stats cards
        Padding(
          padding: AppSpacing.paddingLg,
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Products',
                  admin.products.length.toString(),
                  Icons.inventory_2_outlined,
                  AppColors.primary,
                ),
              ),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: _buildStatCard(
                  'Featured',
                  admin.products.where((p) => p.isFeatured).length.toString(),
                  Icons.star_outline,
                  AppColors.rating,
                ),
              ),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: _buildStatCard(
                  'New Items',
                  admin.products.where((p) => p.isNew).length.toString(),
                  Icons.new_releases_outlined,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ),
        
        // Products table/list
        Expanded(
          child: isWide
              ? _buildProductTable(admin)
              : _buildProductCards(admin),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.verticalGapMd,
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTable(AdminProvider admin) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariant),
        columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: admin.products.map((product) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: const Icon(Icons.image, color: AppColors.textTertiary),
                    ),
                    AppSpacing.horizontalGapMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (product.brand != null)
                          Text(
                            product.brand!,
                            style: AppTypography.bodySmall,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              DataCell(Text(
                AppCategories.getById(product.category)?.name ?? product.category,
              )),
              DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.isFeatured)
                      const Chip(
                        label: Text('Featured'),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (product.isNew)
                      const Chip(
                        label: Text('New'),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _openForm(product: product),
                      color: AppColors.primary,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _confirmDelete(admin, product.id),
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCards(AdminProvider admin) {
    return ListView.separated(
      padding: AppSpacing.paddingLg,
      itemCount: admin.products.length,
      separatorBuilder: (_, __) => AppSpacing.verticalGapMd,
      itemBuilder: (context, index) {
        final product = admin.products[index];
        return _buildProductCard(admin, product);
      },
    );
  }

  Widget _buildProductCard(AdminProvider admin, Product product) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(Icons.image, color: AppColors.textTertiary),
          ),
          AppSpacing.horizontalGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTypography.titleSmall),
                Text(
                  AppCategories.getById(product.category)?.name ?? product.category,
                  style: AppTypography.bodySmall,
                ),
                AppSpacing.verticalGapXs,
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTypography.price.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _openForm(product: product),
                color: AppColors.primary,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDelete(admin, product.id),
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm(AdminProvider admin) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _showForm = false),
                ),
                Text(
                  _editingId != null ? 'Edit Product' : 'Add Product',
                  style: AppTypography.headlineSmall,
                ),
              ],
            ),
            AppSpacing.verticalGapXxl,
            
            AppTextField(
              label: 'Product Name',
              controller: _nameController,
              hint: 'Enter product name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            AppSpacing.verticalGapLg,
            
            AppTextField(
              label: 'Description',
              controller: _descriptionController,
              hint: 'Enter product description',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            AppSpacing.verticalGapLg,
            
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Price',
                    controller: _priceController,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                AppSpacing.horizontalGapMd,
                Expanded(
                  child: AppTextField(
                    label: 'Original Price (Optional)',
                    controller: _originalPriceController,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGapLg,
            
            Text('Category', style: AppTypography.labelLarge),
            AppSpacing.verticalGapSm,
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: AppCategories.all.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            AppSpacing.verticalGapLg,
            
            AppTextField(
              label: 'Brand (Optional)',
              controller: _brandController,
              hint: 'Enter brand name',
            ),
            AppSpacing.verticalGapLg,
            
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: _isFeatured,
                    onChanged: (value) => setState(() => _isFeatured = value ?? false),
                    title: const Text('Featured'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    value: _isNew,
                    onChanged: (value) => setState(() => _isNew = value ?? false),
                    title: const Text('New'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGapXxl,
            
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    isOutlined: true,
                    onPressed: () => setState(() => _showForm = false),
                  ),
                ),
                AppSpacing.horizontalGapMd,
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: _editingId != null ? 'Update Product' : 'Add Product',
                    isLoading: admin.isLoading,
                    onPressed: () => _saveProduct(admin),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openForm({Product? product}) {
    if (product != null) {
      _editingId = product.id;
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _originalPriceController.text = product.originalPrice?.toString() ?? '';
      _brandController.text = product.brand ?? '';
      _selectedCategory = product.category;
      _isFeatured = product.isFeatured;
      _isNew = product.isNew;
    } else {
      _editingId = null;
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _originalPriceController.clear();
      _brandController.clear();
      _selectedCategory = 'phone-cases';
      _isFeatured = false;
      _isNew = false;
    }
    setState(() => _showForm = true);
  }

  void _saveProduct(AdminProvider admin) async {
    if (_formKey.currentState?.validate() ?? false) {
      final product = Product(
        id: _editingId ?? admin.generateProductId(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        originalPrice: _originalPriceController.text.isNotEmpty
            ? double.parse(_originalPriceController.text)
            : null,
        category: _selectedCategory,
        images: [DemoData.getPlaceholderImage(DateTime.now().millisecond)],
        brand: _brandController.text.isNotEmpty ? _brandController.text : null,
        isFeatured: _isFeatured,
        isNew: _isNew,
      );

      if (_editingId != null) {
        await admin.updateProduct(product);
      } else {
        await admin.addProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingId != null ? 'Product updated!' : 'Product added!',
            ),
          ),
        );
        setState(() => _showForm = false);
      }
    }
  }

  void _confirmDelete(AdminProvider admin, String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await admin.deleteProduct(productId);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

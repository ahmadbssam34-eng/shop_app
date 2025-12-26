/// Product Model for Gadget Market
/// Easy to integrate with Firebase backend later
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final bool isFeatured;
  final bool isNew;
  final List<String>? colors;
  final List<String>? variants;
  final Map<String, dynamic>? specifications;
  final String? brand;
  final int stockQuantity;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.inStock = true,
    this.isFeatured = false,
    this.isNew = false,
    this.colors,
    this.variants,
    this.specifications,
    this.brand,
    this.stockQuantity = 100,
  });

  /// Calculate discount percentage
  int? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice! * 100).round();
  }

  /// Check if product has discount
  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  /// Get primary image
  String get primaryImage => images.isNotEmpty ? images.first : '';

  /// Convert to JSON for easy storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'colors': colors,
      'variants': variants,
      'specifications': specifications,
      'brand': brand,
      'stockQuantity': stockQuantity,
    };
  }

  /// Create from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      category: json['category'] as String,
      images: List<String>.from(json['images'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      inStock: json['inStock'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'] as List)
          : null,
      variants: json['variants'] != null
          ? List<String>.from(json['variants'] as List)
          : null,
      specifications: json['specifications'] as Map<String, dynamic>?,
      brand: json['brand'] as String?,
      stockQuantity: json['stockQuantity'] as int? ?? 100,
    );
  }

  /// Copy with modifications
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    List<String>? images,
    double? rating,
    int? reviewCount,
    bool? inStock,
    bool? isFeatured,
    bool? isNew,
    List<String>? colors,
    List<String>? variants,
    Map<String, dynamic>? specifications,
    String? brand,
    int? stockQuantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      inStock: inStock ?? this.inStock,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      colors: colors ?? this.colors,
      variants: variants ?? this.variants,
      specifications: specifications ?? this.specifications,
      brand: brand ?? this.brand,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final String imageUrl;
  final List<String> additionalImages;
  final String? videoUrl;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFeatured;
  final bool isNew;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.imageUrl,
    this.additionalImages = const [],
    this.videoUrl,
    required this.category,
    required this.brand,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isFeatured = false,
    this.isNew = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      discountPercentage: json['discount_percentage'],
      imageUrl: json['image_url'],
      additionalImages: List<String>.from(json['additional_images'] ?? []),
      videoUrl: json['video_url'],
      category: json['category'],
      brand: json['brand'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      stock: json['stock'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      isNew: json['is_new'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'additional_images': additionalImages,
      'video_url': videoUrl,
      'category': category,
      'brand': brand,
      'rating': rating,
      'review_count': reviewCount,
      'stock': stock,
      'is_featured': isFeatured,
      'is_new': isNew,
    };
  }
}

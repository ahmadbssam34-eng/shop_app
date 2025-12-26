/// Review Model for Gadget Market
class Review {
  final String id;
  final String productId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final List<String>? images;

  const Review({
    required this.id,
    required this.productId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'isVerifiedPurchase': isVerifiedPurchase,
      'helpfulCount': helpfulCount,
      'images': images,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
    );
  }
}

/// Sample reviews for demo
class DemoReviews {
  DemoReviews._();

  static final List<Review> all = [
    Review(
      id: 'r1',
      productId: 'p1',
      userName: 'John D.',
      rating: 5.0,
      comment: 'Excellent quality case! Fits perfectly and feels premium. Highly recommend.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isVerifiedPurchase: true,
      helpfulCount: 12,
    ),
    Review(
      id: 'r2',
      productId: 'p1',
      userName: 'Sarah M.',
      rating: 4.0,
      comment: 'Good product, shipping was fast. The color is slightly different from the picture.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isVerifiedPurchase: true,
      helpfulCount: 8,
    ),
    Review(
      id: 'r3',
      productId: 'p2',
      userName: 'Mike R.',
      rating: 5.0,
      comment: 'Best charger I have ever used. Super fast charging and well built.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isVerifiedPurchase: true,
      helpfulCount: 15,
    ),
    Review(
      id: 'r4',
      productId: 'p3',
      userName: 'Emily K.',
      rating: 4.5,
      comment: 'Great sound quality for the price. Battery life is impressive too.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isVerifiedPurchase: true,
      helpfulCount: 22,
    ),
    Review(
      id: 'r5',
      productId: 'p4',
      userName: 'David L.',
      rating: 5.0,
      comment: 'Saved me multiple times! Compact and charges my phone twice over.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isVerifiedPurchase: true,
      helpfulCount: 18,
    ),
  ];

  static List<Review> getByProductId(String productId) {
    return all.where((r) => r.productId == productId).toList();
  }
}

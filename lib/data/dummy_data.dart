import 'models/product_model.dart';

class DummyData {
  static final List<Product> products = [
    Product(
      id: '1',
      title: 'سماعات سوني اللاسلكية XM5',
      description:
          'سماعات بلوتوث بتقنية إلغاء الضوضاء النشط، عمر البطارية 30 ساعة، جودة صوت عالية الدقة مع ميكروفون مدمج للمكالمات',
      price: 899.0,
      originalPrice: 1199.0,
      discountPercentage: 25,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
      additionalImages: [
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800',
      ],
      category: 'إلكترونيات',
      brand: 'Sony',
      rating: 4.8,
      reviewCount: 824,
      stock: 12,
      isFeatured: true,
    ),
    Product(
      id: '2',
      title: 'ساعة ذكية Galaxy Watch 6',
      description:
          'ساعة ذكية بشاشة AMOLED مقاس 1.4 بوصة، مقاومة للماء، تتبع صحي شامل مع أكثر من 90 وضع رياضي',
      price: 1299.0,
      originalPrice: 1599.0,
      discountPercentage: 19,
      imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800',
      additionalImages: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
      ],
      category: 'إلكترونيات',
      brand: 'Samsung',
      rating: 4.6,
      reviewCount: 532,
      stock: 8,
      isFeatured: true,
    ),
    Product(
      id: '3',
      title: 'كاميرا Canon EOS R6',
      description:
          'كاميرا احترافية بدون مرآة، مستشعر 20 ميجابكسل، تصوير فيديو 4K، مثالية للمصورين المحترفين',
      price: 8999.0,
      imageUrl: 'https://images.unsplash.com/photo-1606980413569-9adae61dd1a8?w=800',
      category: 'إلكترونيات',
      brand: 'Canon',
      rating: 4.9,
      reviewCount: 234,
      stock: 5,
      isFeatured: true,
    ),
    Product(
      id: '4',
      title: 'حقيبة ظهر عصرية للسفر',
      description:
          'حقيبة ظهر مقاومة للماء بسعة 30 لتر، جيوب متعددة، مناسبة للكمبيوتر المحمول حتى 15.6 بوصة',
      price: 249.0,
      originalPrice: 349.0,
      discountPercentage: 29,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
      category: 'أزياء',
      brand: 'TravelPro',
      rating: 4.5,
      reviewCount: 892,
      stock: 24,
    ),
    Product(
      id: '5',
      title: 'نظارات شمسية بولارايزد',
      description: 'نظارات شمسية عصرية بعدسات مستقطبة، حماية 100% من الأشعة فوق البنفسجية، إطار معدني أنيق',
      price: 199.0,
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800',
      category: 'أزياء',
      brand: 'RayBan',
      rating: 4.7,
      reviewCount: 456,
      stock: 18,
      isNew: true,
    ),
    Product(
      id: '6',
      title: 'حذاء رياضي Nike Air Max',
      description: 'حذاء رياضي مريح للجري والاستخدام اليومي، تقنية Air Max للتوسيد، متوفر بعدة ألوان',
      price: 599.0,
      originalPrice: 799.0,
      discountPercentage: 25,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
      category: 'أزياء',
      brand: 'Nike',
      rating: 4.8,
      reviewCount: 1234,
      stock: 15,
      isFeatured: true,
    ),
    Product(
      id: '7',
      title: 'كرسي مكتب مريح',
      description: 'كرسي مكتب بتصميم إرجونومي، قابل للتعديل، دعم قطني ممتاز، مثالي للعمل الطويل',
      price: 749.0,
      imageUrl: 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=800',
      category: 'منزل',
      brand: 'ComfortPro',
      rating: 4.6,
      reviewCount: 328,
      stock: 7,
    ),
    Product(
      id: '8',
      title: 'مصباح LED ذكي',
      description: 'مصباح LED قابل للتحكم عبر التطبيق، 16 مليون لون، توافق مع Alexa و Google Home',
      price: 149.0,
      originalPrice: 199.0,
      discountPercentage: 25,
      imageUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=800',
      category: 'منزل',
      brand: 'Philips Hue',
      rating: 4.7,
      reviewCount: 678,
      stock: 32,
      isNew: true,
    ),
  ];

  static final List<String> categories = [
    'الكل',
    'إلكترونيات',
    'أزياء',
    'منزل',
    'رياضة',
    'جمال',
  ];

  static final List<String> heroImages = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=1200',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200',
    'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=1200',
  ];

  static final List<Map<String, String>> heroTexts = [
    {
      'title': 'عروض نهاية الموسم',
      'subtitle': 'خصم حتى 50% على جميع المنتجات',
    },
    {
      'title': 'أحدث الأجهزة الذكية',
      'subtitle': 'اكتشف أحدث التقنيات بأفضل الأسعار',
    },
    {
      'title': 'أزياء عصرية 2024',
      'subtitle': 'تشكيلة جديدة من أفضل الماركات',
    },
    {
      'title': 'توصيل مجاني',
      'subtitle': 'على جميع الطلبات فوق 200 ريال',
    },
  ];
}

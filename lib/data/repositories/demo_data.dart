import '../models/product.dart';

/// Demo Product Data for Gadget Market
/// Easy to replace with Firebase backend later
class DemoData {
  DemoData._();

  /// Placeholder image URLs using picsum.photos
  /// Replace with actual product images when integrating backend
  static String getPlaceholderImage(int seed, {int width = 400, int height = 400}) {
    return 'https://picsum.photos/seed/$seed/$width/$height';
  }

  /// All demo products
  static final List<Product> products = [
    // === PHONE CASES ===
    Product(
      id: 'p1',
      name: 'Premium Silicone Case',
      description: 'Ultra-thin silicone case with soft-touch finish. Provides excellent grip and protection against scratches and minor drops. Compatible with wireless charging.',
      price: 19.99,
      originalPrice: 29.99,
      category: 'phone-cases',
      images: [
        getPlaceholderImage(101),
        getPlaceholderImage(102),
        getPlaceholderImage(103),
      ],
      rating: 4.8,
      reviewCount: 234,
      isFeatured: true,
      isNew: false,
      colors: ['Black', 'Navy', 'Rose', 'Mint'],
      brand: 'GadgetGuard',
      specifications: {
        'Material': 'Liquid Silicone',
        'Compatibility': 'iPhone 15/15 Pro',
        'Weight': '25g',
        'Wireless Charging': 'Yes',
      },
    ),
    Product(
      id: 'p2',
      name: 'Clear Crystal Case',
      description: 'Crystal clear hard case that shows off your phone design. Anti-yellowing technology keeps it looking new. Raised edges protect camera and screen.',
      price: 14.99,
      category: 'phone-cases',
      images: [
        getPlaceholderImage(104),
        getPlaceholderImage(105),
      ],
      rating: 4.5,
      reviewCount: 189,
      isFeatured: false,
      isNew: true,
      brand: 'ClearView',
      specifications: {
        'Material': 'PC + TPU',
        'Compatibility': 'Samsung Galaxy S24',
        'Weight': '20g',
        'Anti-Yellowing': 'Yes',
      },
    ),
    Product(
      id: 'p3',
      name: 'Leather Wallet Case',
      description: 'Genuine leather case with card slots and magnetic closure. Perfect for minimalists who want to carry phone and essentials together.',
      price: 39.99,
      originalPrice: 49.99,
      category: 'phone-cases',
      images: [
        getPlaceholderImage(106),
        getPlaceholderImage(107),
        getPlaceholderImage(108),
      ],
      rating: 4.7,
      reviewCount: 156,
      isFeatured: true,
      colors: ['Brown', 'Black', 'Tan'],
      brand: 'LeatherCraft',
      specifications: {
        'Material': 'Genuine Leather',
        'Card Slots': '3',
        'Cash Pocket': 'Yes',
        'Magnetic Closure': 'Yes',
      },
    ),

    // === CHARGERS & CABLES ===
    Product(
      id: 'p4',
      name: '65W GaN Fast Charger',
      description: 'Compact GaN technology charger with 65W output. Charge your laptop, phone and tablet simultaneously. Universal compatibility with PD 3.0.',
      price: 45.99,
      originalPrice: 59.99,
      category: 'chargers',
      images: [
        getPlaceholderImage(201),
        getPlaceholderImage(202),
        getPlaceholderImage(203),
      ],
      rating: 4.9,
      reviewCount: 412,
      isFeatured: true,
      isNew: true,
      brand: 'PowerMax',
      specifications: {
        'Power Output': '65W',
        'Technology': 'GaN III',
        'Ports': '2x USB-C, 1x USB-A',
        'Protocol': 'PD 3.0, QC 4.0',
        'Input': '100-240V',
      },
    ),
    Product(
      id: 'p5',
      name: 'USB-C to Lightning Cable 2m',
      description: 'MFi certified braided nylon cable. Fast charging up to 27W with durable connectors. 10,000+ bend lifespan.',
      price: 18.99,
      category: 'chargers',
      images: [
        getPlaceholderImage(204),
        getPlaceholderImage(205),
      ],
      rating: 4.6,
      reviewCount: 289,
      colors: ['Black', 'White', 'Space Gray'],
      brand: 'CableLink',
      specifications: {
        'Length': '2 meters',
        'Material': 'Braided Nylon',
        'Certification': 'MFi Certified',
        'Max Power': '27W',
      },
    ),
    Product(
      id: 'p6',
      name: 'Wireless Charging Pad',
      description: '15W fast wireless charging pad with temperature control. LED indicator and anti-slip surface. Works through most cases up to 8mm thick.',
      price: 29.99,
      originalPrice: 39.99,
      category: 'chargers',
      images: [
        getPlaceholderImage(206),
        getPlaceholderImage(207),
      ],
      rating: 4.4,
      reviewCount: 198,
      isFeatured: true,
      brand: 'WirelessPro',
      specifications: {
        'Power': '15W Max',
        'Standard': 'Qi Certified',
        'Case Compatibility': 'Up to 8mm',
        'LED Indicator': 'Yes',
      },
    ),

    // === AUDIO ===
    Product(
      id: 'p7',
      name: 'True Wireless Earbuds Pro',
      description: 'Premium true wireless earbuds with active noise cancellation. 32 hours total battery life with case. IPX5 water resistant for workouts.',
      price: 89.99,
      originalPrice: 129.99,
      category: 'audio',
      images: [
        getPlaceholderImage(301),
        getPlaceholderImage(302),
        getPlaceholderImage(303),
      ],
      rating: 4.7,
      reviewCount: 567,
      isFeatured: true,
      isNew: true,
      colors: ['Black', 'White', 'Navy'],
      brand: 'SoundWave',
      specifications: {
        'Driver': '12mm Dynamic',
        'ANC': 'Active Noise Cancellation',
        'Battery': '8h + 24h (case)',
        'Bluetooth': '5.3',
        'Water Resistance': 'IPX5',
      },
    ),
    Product(
      id: 'p8',
      name: 'Over-Ear Bluetooth Headphones',
      description: 'Comfortable over-ear headphones with premium sound. 40mm drivers deliver rich bass. Foldable design for portability.',
      price: 59.99,
      category: 'audio',
      images: [
        getPlaceholderImage(304),
        getPlaceholderImage(305),
      ],
      rating: 4.5,
      reviewCount: 234,
      colors: ['Black', 'Silver', 'Rose Gold'],
      brand: 'AudioTech',
      specifications: {
        'Driver': '40mm',
        'Battery': '30 hours',
        'Bluetooth': '5.2',
        'Foldable': 'Yes',
        'Microphone': 'Built-in',
      },
    ),

    // === POWER BANKS ===
    Product(
      id: 'p9',
      name: '20000mAh Power Bank',
      description: 'High capacity power bank with 22.5W fast charging. Charges iPhone 5 times or laptop once. LED display shows remaining battery.',
      price: 49.99,
      originalPrice: 69.99,
      category: 'power-banks',
      images: [
        getPlaceholderImage(401),
        getPlaceholderImage(402),
        getPlaceholderImage(403),
      ],
      rating: 4.8,
      reviewCount: 445,
      isFeatured: true,
      colors: ['Black', 'White'],
      brand: 'PowerMax',
      specifications: {
        'Capacity': '20000mAh',
        'Output': '22.5W Max',
        'Ports': '2x USB-A, 1x USB-C',
        'Display': 'LED Battery Indicator',
        'Weight': '350g',
      },
    ),
    Product(
      id: 'p10',
      name: 'Slim 10000mAh Power Bank',
      description: 'Ultra-slim power bank that fits in your pocket. 18W PD fast charging with USB-C. Aircraft-grade aluminum casing.',
      price: 29.99,
      category: 'power-banks',
      images: [
        getPlaceholderImage(404),
        getPlaceholderImage(405),
      ],
      rating: 4.6,
      reviewCount: 312,
      isNew: true,
      colors: ['Silver', 'Space Gray', 'Gold'],
      brand: 'SlimCharge',
      specifications: {
        'Capacity': '10000mAh',
        'Output': '18W PD',
        'Thickness': '12mm',
        'Material': 'Aluminum',
        'Weight': '180g',
      },
    ),

    // === SCREEN PROTECTORS ===
    Product(
      id: 'p11',
      name: 'Tempered Glass Screen Protector',
      description: '9H hardness tempered glass with oleophobic coating. Easy bubble-free installation with alignment frame. 2-pack value.',
      price: 12.99,
      category: 'screen-protectors',
      images: [
        getPlaceholderImage(501),
        getPlaceholderImage(502),
      ],
      rating: 4.4,
      reviewCount: 678,
      brand: 'ScreenShield',
      specifications: {
        'Hardness': '9H',
        'Thickness': '0.33mm',
        'Coating': 'Oleophobic',
        'Quantity': '2 Pack',
        'Installation': 'Easy Frame Included',
      },
    ),
    Product(
      id: 'p12',
      name: 'Privacy Screen Protector',
      description: 'Anti-spy tempered glass that blocks viewing from sides. Perfect for sensitive information. Touch sensitivity preserved.',
      price: 19.99,
      originalPrice: 24.99,
      category: 'screen-protectors',
      images: [
        getPlaceholderImage(503),
        getPlaceholderImage(504),
      ],
      rating: 4.3,
      reviewCount: 156,
      brand: 'PrivacyGuard',
      specifications: {
        'Privacy Angle': '28°',
        'Hardness': '9H',
        'Anti-Spy': 'Yes',
        'Touch Sensitivity': '99%',
      },
    ),

    // === HOME TOOLS ===
    Product(
      id: 'p13',
      name: 'Electric Screwdriver Set',
      description: 'Cordless electric screwdriver with 60 precision bits. USB rechargeable with torque adjustment. Perfect for electronics repair.',
      price: 34.99,
      originalPrice: 44.99,
      category: 'home-tools',
      images: [
        getPlaceholderImage(601),
        getPlaceholderImage(602),
        getPlaceholderImage(603),
      ],
      rating: 4.7,
      reviewCount: 345,
      isFeatured: true,
      brand: 'ToolMaster',
      specifications: {
        'Bits Included': '60',
        'Torque Settings': '3',
        'Battery': 'Li-ion 350mAh',
        'Charging': 'USB-C',
        'LED Light': 'Yes',
      },
    ),
    Product(
      id: 'p14',
      name: 'Digital Multimeter',
      description: 'Professional digital multimeter for voltage, current, resistance and continuity. Auto-ranging with backlit display. Comes with test leads.',
      price: 28.99,
      category: 'home-tools',
      images: [
        getPlaceholderImage(604),
        getPlaceholderImage(605),
      ],
      rating: 4.5,
      reviewCount: 189,
      brand: 'ElectroPro',
      specifications: {
        'Functions': 'V/A/R/Continuity',
        'Auto-ranging': 'Yes',
        'Display': 'LCD Backlit',
        'Safety Rating': 'CAT III',
      },
    ),
    Product(
      id: 'p15',
      name: 'Precision Tool Kit 140-in-1',
      description: 'Complete precision tool kit for electronics, watches and jewelry repair. Magnetic mat and anti-static wrist strap included.',
      price: 39.99,
      category: 'home-tools',
      images: [
        getPlaceholderImage(606),
        getPlaceholderImage(607),
      ],
      rating: 4.6,
      reviewCount: 267,
      isNew: true,
      brand: 'PrecisionPro',
      specifications: {
        'Pieces': '140',
        'Magnetic Mat': 'Included',
        'Anti-static Strap': 'Included',
        'Case': 'Organized Carry Case',
      },
    ),

    // === LIGHTING ===
    Product(
      id: 'p16',
      name: 'Smart LED Strip Lights 5m',
      description: 'RGB smart LED strip with app control and voice assistant support. Music sync mode and 16 million colors. Easy adhesive backing.',
      price: 24.99,
      originalPrice: 34.99,
      category: 'lighting',
      images: [
        getPlaceholderImage(701),
        getPlaceholderImage(702),
        getPlaceholderImage(703),
      ],
      rating: 4.4,
      reviewCount: 423,
      isFeatured: true,
      brand: 'LightWave',
      specifications: {
        'Length': '5 meters',
        'Colors': '16 Million RGB',
        'Control': 'App / Voice / Remote',
        'Music Sync': 'Yes',
        'Compatible': 'Alexa, Google Home',
      },
    ),
    Product(
      id: 'p17',
      name: 'Rechargeable Desk Lamp',
      description: 'Cordless LED desk lamp with touch control. 3 brightness levels and warm/cool color temperature. USB rechargeable lasts 40 hours.',
      price: 32.99,
      category: 'lighting',
      images: [
        getPlaceholderImage(704),
        getPlaceholderImage(705),
      ],
      rating: 4.6,
      reviewCount: 178,
      brand: 'LumiDesk',
      specifications: {
        'Battery': '40 hours',
        'Brightness': '3 Levels',
        'Color Temp': 'Warm/Neutral/Cool',
        'Charging': 'USB-C',
        'Touch Control': 'Yes',
      },
    ),

    // === SMART HOME ===
    Product(
      id: 'p18',
      name: 'Smart Plug 4-Pack',
      description: 'WiFi smart plugs with energy monitoring. Schedule and remote control from anywhere. Works with Alexa and Google Home.',
      price: 29.99,
      originalPrice: 39.99,
      category: 'smart-home',
      images: [
        getPlaceholderImage(801),
        getPlaceholderImage(802),
      ],
      rating: 4.5,
      reviewCount: 534,
      isFeatured: true,
      brand: 'SmartLife',
      specifications: {
        'Quantity': '4 Pack',
        'Max Load': '15A / 1800W',
        'WiFi': '2.4GHz',
        'Energy Monitor': 'Yes',
        'Voice Control': 'Alexa, Google',
      },
    ),
    Product(
      id: 'p19',
      name: 'Motion Sensor Night Light',
      description: 'Automatic motion-activated LED night light. Adjustable brightness with warm white glow. USB rechargeable, stick anywhere.',
      price: 16.99,
      category: 'smart-home',
      images: [
        getPlaceholderImage(803),
        getPlaceholderImage(804),
      ],
      rating: 4.3,
      reviewCount: 289,
      brand: 'NightGlow',
      specifications: {
        'Sensor': 'PIR Motion',
        'Range': '10ft / 120°',
        'Battery': 'USB Rechargeable',
        'Auto-off': '15/30/60 seconds',
      },
    ),
    Product(
      id: 'p20',
      name: 'Smart Door Sensor',
      description: 'WiFi door/window sensor with instant alerts. No hub required. Easy peel-and-stick installation. Works with smart home routines.',
      price: 19.99,
      category: 'smart-home',
      images: [
        getPlaceholderImage(805),
        getPlaceholderImage(806),
      ],
      rating: 4.4,
      reviewCount: 167,
      isNew: true,
      brand: 'SecureSense',
      specifications: {
        'Connection': 'WiFi Direct',
        'Hub Required': 'No',
        'Battery': 'CR2032 (1 year)',
        'Alerts': 'Push Notification',
        'Installation': 'Adhesive',
      },
    ),
  ];

  /// Get featured products
  static List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  /// Get new products
  static List<Product> get newProducts =>
      products.where((p) => p.isNew).toList();

  /// Get products by category
  static List<Product> getByCategory(String categoryId) =>
      products.where((p) => p.category == categoryId).toList();

  /// Get product by ID
  static Product? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Search products
  static List<Product> search(String query) {
    final lowerQuery = query.toLowerCase();
    return products.where((p) =>
      p.name.toLowerCase().contains(lowerQuery) ||
      p.description.toLowerCase().contains(lowerQuery) ||
      p.category.toLowerCase().contains(lowerQuery) ||
      (p.brand?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  /// Get products with filters
  static List<Product> getFiltered({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStock,
    String? sortBy,
  }) {
    var filtered = List<Product>.from(products);

    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice).toList();
    }

    if (minRating != null) {
      filtered = filtered.where((p) => p.rating >= minRating).toList();
    }

    if (inStock != null && inStock) {
      filtered = filtered.where((p) => p.inStock).toList();
    }

    // Sort
    switch (sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        filtered.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
        break;
      case 'popular':
      default:
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    return filtered;
  }
}

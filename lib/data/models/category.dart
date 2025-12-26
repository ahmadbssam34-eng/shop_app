import 'package:flutter/material.dart';

/// Category Model for Gadget Market
class Category {
  final String id;
  final String name;
  final String? description;
  final IconData icon;
  final String? imageUrl;
  final int productCount;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    this.imageUrl,
    this.productCount = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'productCount': productCount,
      'isActive': isActive,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json, IconData icon) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: icon,
      imageUrl: json['imageUrl'] as String?,
      productCount: json['productCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Predefined categories for Gadget Market
class AppCategories {
  AppCategories._();

  static const List<Category> all = [
    Category(
      id: 'phone-cases',
      name: 'Phone Cases',
      description: 'Protective cases for all phone models',
      icon: Icons.phone_android,
      productCount: 45,
    ),
    Category(
      id: 'chargers',
      name: 'Chargers & Cables',
      description: 'Fast chargers and quality cables',
      icon: Icons.electrical_services,
      productCount: 32,
    ),
    Category(
      id: 'audio',
      name: 'Audio',
      description: 'Headphones, earbuds and speakers',
      icon: Icons.headphones,
      productCount: 28,
    ),
    Category(
      id: 'power-banks',
      name: 'Power Banks',
      description: 'Portable power solutions',
      icon: Icons.battery_charging_full,
      productCount: 18,
    ),
    Category(
      id: 'screen-protectors',
      name: 'Screen Protectors',
      description: 'Tempered glass and film protectors',
      icon: Icons.screen_lock_portrait,
      productCount: 25,
    ),
    Category(
      id: 'home-tools',
      name: 'Home Tools',
      description: 'Essential tools for home use',
      icon: Icons.home_repair_service,
      productCount: 38,
    ),
    Category(
      id: 'lighting',
      name: 'Lighting',
      description: 'LED lights and smart bulbs',
      icon: Icons.lightbulb,
      productCount: 22,
    ),
    Category(
      id: 'smart-home',
      name: 'Smart Home',
      description: 'Smart plugs, switches and sensors',
      icon: Icons.smart_toy,
      productCount: 15,
    ),
  ];

  static Category? getById(String id) {
    try {
      return all.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }
}

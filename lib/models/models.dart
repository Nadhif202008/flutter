import 'package:flutter/foundation.dart';

class FoodCategory {
  final String id;
  final String name;
  final String icon;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final bool isPopular;
  final double rating;
  final String category;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.isPopular = false,
    this.rating = 4.8,
    required this.category,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final double deliveryFee;
  final double distance;
  final String imageUrl;
  final String bannerUrl;
  final bool isPromo;
  final String? promoText;
  final List<String> categories;
  final List<FoodItem> menu;
  bool isFavorite;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.distance,
    required this.imageUrl,
    required this.bannerUrl,
    this.isPromo = false,
    this.promoText,
    required this.categories,
    required this.menu,
    this.isFavorite = false,
  });
}

class CartItem {
  final FoodItem foodItem;
  int quantity;
  String? notes;
  List<String> selectedOptions;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    this.notes,
    this.selectedOptions = const [],
  });

  double get totalPrice => foodItem.price * quantity;
}

enum OrderStatus {
  accepted,
  preparing,
  onTheWay,
  delivered,
}

class Order {
  final String id;
  final Restaurant restaurant;
  final List<CartItem> items;
  final String deliveryAddress;
  OrderStatus status;
  final DateTime orderTime;
  final String estimatedDelivery;
  final String driverName;
  final String driverPhone;
  final String driverPlate;
  final double totalAmount;
  final String paymentMethod;

  Order({
    required this.id,
    required this.restaurant,
    required this.items,
    required this.deliveryAddress,
    required this.status,
    required this.orderTime,
    required this.estimatedDelivery,
    required this.driverName,
    required this.driverPhone,
    required this.driverPlate,
    required this.totalAmount,
    required this.paymentMethod,
  });
}

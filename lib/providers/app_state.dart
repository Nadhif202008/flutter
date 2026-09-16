import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  final List<CartItem> _cartItems = [];
  Restaurant? _currentCartRestaurant;
  final List<Order> _orders = [];
  Order? _activeOrder;

  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String? _appliedVoucherCode;
  double _appliedDiscountAmount = 0.0;

  String _deliveryAddress = 'Jl. Jend. Sudirman No. 45, Jakarta Pusat';

  UserProfile? _currentUser;
  final List<UserProfile> _registeredUsers = [];
  final Map<String, String> _userPasswords = {};

  AppState() {
    _restaurants = MockData.getRestaurants();
    _seedDefaultUser();
  }


  void _seedDefaultUser() {
    final demoUser = UserProfile(
      id: 'USR-001',
      name: 'Ahmad Nadhif',
      email: 'nadhif@gmail.com',
      phone: '081234567890',
      isVip: true,
    );
    _registeredUsers.add(demoUser);
    _userPasswords['nadhif@gmail.com'] = '123456';
    _userPasswords['081234567890'] = '123456';
    // Initially not logged in to show Login screen
    _currentUser = null;
  }

  // Getters
  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<Restaurant> get restaurants => _restaurants;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Restaurant? get currentCartRestaurant => _currentCartRestaurant;
  List<Order> get orders => List.unmodifiable(_orders);
  Order? get activeOrder => _activeOrder;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String? get appliedVoucherCode => _appliedVoucherCode;
  double get appliedDiscountAmount => _appliedDiscountAmount;
  String get deliveryAddress => _deliveryAddress;

  // Auth Methods
  String? login(String emailOrPhone, String password) {
    final cleanInput = emailOrPhone.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanInput.isEmpty || cleanPassword.isEmpty) {
      return 'Email/No. HP dan Password wajib diisi';
    }

    final user = _registeredUsers.firstWhere(
      (u) => u.email.toLowerCase() == cleanInput || u.phone == cleanInput,
      orElse: () => UserProfile(id: '', name: '', email: '', phone: ''),
    );

    if (user.id.isEmpty) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    }

    final storedPassword = _userPasswords[user.email.toLowerCase()] ?? _userPasswords[user.phone];
    if (storedPassword != cleanPassword) {
      return 'Password yang Anda masukkan salah.';
    }

    _currentUser = user;
    notifyListeners();
    return null; // Success
  }

  String? register({
    required String name,
    required String email,
    required String phone,
    required String password,
    bool autoLogin = false,
  }) {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phone.trim();
    final cleanPassword = password.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPhone.isEmpty || cleanPassword.isEmpty) {
      return 'Semua bidang data wajib diisi';
    }

    if (cleanPassword.length < 6) {
      return 'Password minimal 6 karakter';
    }

    final exists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == cleanEmail || u.phone == cleanPhone,
    );
    if (exists) {
      return 'Email atau No. HP sudah terdaftar. Silakan login.';
    }

    final newUser = UserProfile(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: cleanName,
      email: cleanEmail,
      phone: cleanPhone,
      isVip: true,
    );

    _registeredUsers.add(newUser);
    _userPasswords[cleanEmail] = cleanPassword;
    _userPasswords[cleanPhone] = cleanPassword;
    if (autoLogin) {
      _currentUser = newUser;
    }
    notifyListeners();
    return null; // Success
  }


  void loginAsDemo() {
    login('nadhif@gmail.com', '123456');
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }


  List<Restaurant> get filteredRestaurants {
    return _restaurants.where((r) {
      final matchesCategory = _selectedCategoryId == 'all' || 
          r.category.toLowerCase().contains(_selectedCategoryId.toLowerCase()) ||
          r.categories.any((c) => c.toLowerCase().contains(_selectedCategoryId.toLowerCase()));
      
      final matchesSearch = _searchQuery.isEmpty ||
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.menu.any((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Restaurant> get favoriteRestaurants {
    return _restaurants.where((r) => r.isFavorite).toList();
  }

  int get cartTotalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get cartSubtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (_cartItems.isEmpty || _currentCartRestaurant == null) return 0.0;
    if (_appliedVoucherCode == 'ONGKIRGRATIS') return 0.0;
    return _currentCartRestaurant!.deliveryFee;
  }

  double get serviceFee => _cartItems.isEmpty ? 0.0 : 3000.0;

  double get finalTotal {
    final sub = cartSubtotal;
    if (sub == 0) return 0;
    final totalBeforeDiscount = sub + deliveryFee + serviceFee;
    return (totalBeforeDiscount - _appliedDiscountAmount).clamp(0, double.infinity);
  }

  // Actions
  void setCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void toggleFavorite(Restaurant restaurant) {
    restaurant.isFavorite = !restaurant.isFavorite;
    notifyListeners();
  }

  void addToCart(Restaurant restaurant, FoodItem foodItem, {int quantity = 1, String? notes, List<String>? selectedOptions}) {
    if (_currentCartRestaurant != null && _currentCartRestaurant!.id != restaurant.id) {
      // Clear cart if adding from a different restaurant
      _cartItems.clear();
    }
    _currentCartRestaurant = restaurant;

    final index = _cartItems.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
      if (notes != null) _cartItems[index].notes = notes;
    } else {
      _cartItems.add(CartItem(
        foodItem: foodItem,
        quantity: quantity,
        notes: notes,
        selectedOptions: selectedOptions ?? [],
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(FoodItem foodItem, int delta) {
    final index = _cartItems.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
    }
    if (_cartItems.isEmpty) {
      _currentCartRestaurant = null;
      _appliedVoucherCode = null;
      _appliedDiscountAmount = 0.0;
    }
    notifyListeners();
  }

  bool applyVoucher(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'GRABDISCOUNT50') {
      _appliedVoucherCode = cleanCode;
      _appliedDiscountAmount = (cartSubtotal * 0.5).clamp(0, 25000);
      notifyListeners();
      return true;
    } else if (cleanCode == 'ONGKIRGRATIS') {
      _appliedVoucherCode = cleanCode;
      _appliedDiscountAmount = _currentCartRestaurant?.deliveryFee ?? 8000;
      notifyListeners();
      return true;
    } else if (cleanCode == 'HEMATBANGET') {
      _appliedVoucherCode = cleanCode;
      _appliedDiscountAmount = 15000;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _appliedVoucherCode = null;
    _appliedDiscountAmount = 0.0;
    notifyListeners();
  }

  Order? placeOrder(String paymentMethod) {
    if (_cartItems.isEmpty || _currentCartRestaurant == null) return null;

    final newOrder = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      restaurant: _currentCartRestaurant!,
      items: List.from(_cartItems),
      deliveryAddress: _deliveryAddress,
      status: OrderStatus.accepted,
      orderTime: DateTime.now(),
      estimatedDelivery: '20 - 30 mnt',
      driverName: 'Budi Santoso',
      driverPhone: '0812-3456-7890',
      driverPlate: 'B 4521 SG',
      totalAmount: finalTotal,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;

    // Reset cart
    _cartItems.clear();
    _currentCartRestaurant = null;
    _appliedVoucherCode = null;
    _appliedDiscountAmount = 0.0;

    notifyListeners();
    return newOrder;
  }

  void updateOrderStatus(Order order, OrderStatus newStatus) {
    order.status = newStatus;
    notifyListeners();
  }
}

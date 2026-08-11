import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';
import 'order_tracking_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final AppState appState;

  const MainNavigationPage({super.key, required this.appState});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;

    final List<Widget> pages = [
      HomePage(appState: state),
      state.activeOrder != null
          ? OrderTrackingPage(order: state.activeOrder!, appState: state)
          : Scaffold(
              appBar: AppBar(title: const Text('Pesanan Saya')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Belum ada pesanan aktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Pesanan yang sedang diantar akan muncul di sini.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
      FavoritesPage(appState: state),
      ProfilePage(appState: state),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: state.activeOrder != null,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.receipt_long_outlined),
              ),
              activeIcon: const Icon(Icons.receipt_long),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: state.favoriteRestaurants.isNotEmpty,
                label: Text('${state.favoriteRestaurants.length}'),
                backgroundColor: Colors.red,
                child: const Icon(Icons.favorite_border),
              ),
              activeIcon: const Icon(Icons.favorite),
              label: 'Favorit',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

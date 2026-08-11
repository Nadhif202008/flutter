import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'restaurant_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  final AppState appState;

  const FavoritesPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final favorites = appState.favoriteRestaurants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restoran Favorit Saya'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Restoran Favorit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati ❤️ pada restoran pilihanmu untuk menyimpannya di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        restaurant.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 60, color: Colors.grey.shade200),
                      ),
                    ),
                    title: Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${restaurant.category} • ⭐ ${restaurant.rating}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => appState.toggleFavorite(restaurant),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurant: restaurant,
                            appState: appState,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

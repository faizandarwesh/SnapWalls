import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _keyFavorites = "favorite_wallpapers";

  // Private constructor to prevent instantiation
  FavoritesStorage._();

  // Save a wallpaper URL to favorites
  static Future<void> addFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    if (!favorites.contains(imageUrl)) {
      favorites.add(imageUrl);
      await prefs.setStringList(_keyFavorites, favorites);
    }
  }

  // Remove a wallpaper URL from favorites
  static Future<void> removeFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    favorites.remove(imageUrl);
    await prefs.setStringList(_keyFavorites, favorites);
  }

  // Check if a wallpaper URL is in favorites
  static Future<bool> isFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    return favorites.contains(imageUrl);
  }

  // Get all favorite wallpapers
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }
}

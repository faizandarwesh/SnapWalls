// lib/controller/favorites_controller.dart
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  // RxList<String> favorites = <String>[].obs;

  final RxList<String> favorites = <String>[
    'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
    'https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg',
    'https://images.pexels.com/photos/1274260/pexels-photo-1274260.jpeg',
    'https://images.pexels.com/photos/1103970/pexels-photo-1103970.jpeg',
    'https://images.pexels.com/photos/33109/fall-autumn-red-season.jpg',
    'https://images.pexels.com/photos/34950/pexels-photo.jpg',
  ].obs;

  bool isFavorite(String url) => favorites.contains(url);

  void toggleFavorite(String url) {
    if (isFavorite(url)) {
      favorites.remove(url);
    } else {
      favorites.add(url);
    }
  }
}

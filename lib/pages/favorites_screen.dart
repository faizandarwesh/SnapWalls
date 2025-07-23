import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_walls/controller/main_controller.dart';
import '../widgets/wallpaper_tile.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final MainController controller =  Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Obx(() {
        final items = controller.favoriteList;
        if (items.isEmpty) {
          return const Center(child: Text("No favorites yet."));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (_, index) {
            return WallpaperTile(
              id: index,
              imageUrl: items[index],
              index: index,
              extent: 200,
            );
          },
        );
      }),
    );
  }
}

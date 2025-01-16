import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../controller/wallpaper_tile_controller.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final WallpaperTileController controller = Get.put(WallpaperTileController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Obx(() {
        if (controller.favoriteList.isEmpty) {
          return const Center(
            child: Text("No favorites yet."),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: controller.favoriteList.length,
          itemBuilder: (context, index) {
            final imageUrl = controller.favoriteList[index];

            return Stack(
              children: [
                // Wallpaper Image
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive()),
                  ),
                ),
                // Remove Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => controller.toggleFavorite(),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

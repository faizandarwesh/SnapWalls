import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../controller/wallpaper_tile_controller.dart';
import '../pages/wallpaper_detail_screen.dart';

class WallpaperTile extends StatefulWidget {
  final int id;
  final String imageUrl;
  final int index;
  final double extent;


  const WallpaperTile({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.index,
    required this.extent,
  });

  @override
  State<WallpaperTile> createState() => _WallpaperTileState();
}

class _WallpaperTileState extends State<WallpaperTile> {

  final WallpaperTileController controller = Get.put(WallpaperTileController());
  RxBool isFavorite = false.obs;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onDoubleTap: () => controller.toggleFavorite(widget.imageUrl,isFavorite), // Trigger animation on double-tap
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailPage(
              imageUrl: widget.imageUrl,
              tag: widget.index.toString(),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          // Wallpaper tile
          Hero(
            tag: widget.index.toString(),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              height: widget.extent,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          ),
          // Rive animation overlay
          Obx(() {
            final isVisible = controller.showAnimation.value;
            final artBoard = controller.riveArtBoard.value;

            if (artBoard == null || !isVisible) return const SizedBox.shrink();

            return Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isVisible ? 1 : 0,
                child: Rive(
                  artboard: artBoard, // Use the loaded artBoard
                  fit: BoxFit.cover, // Ensure the animation covers the full card
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
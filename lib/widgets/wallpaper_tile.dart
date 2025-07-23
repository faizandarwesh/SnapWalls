import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../controller/main_controller.dart';
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

  late final MainController controller;
  RxBool isFavorite = false.obs;

  // Rive animation state per tile
  Artboard? riveArtBoard;
  SMIBool? likeInput;
  bool showAnimation = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MainController>();
    isFavorite.value = controller.favoriteList.contains(widget.imageUrl);
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final data = await rootBundle.load('assets/raw/favorite.riv');
    await RiveFile.initialize();
    final file = RiveFile.import(data);
    final artBoard = file.mainArtboard;
    final controller = StateMachineController.fromArtboard(artBoard, 'State Machine 1');
    if (controller != null) {
      artBoard.addController(controller);
      likeInput = controller.findInput<bool>('Like') as SMIBool?;
    }
    setState(() {
      riveArtBoard = artBoard;
    });
  }

  void triggerFavoriteAnimation() {
    if (likeInput != null) {
      likeInput!.value = true;
    }
    setState(() {
      showAnimation = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        controller.toggleFavorite(widget.imageUrl, isFavorite);
        triggerFavoriteAnimation();
      },
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
          // Rive animation overlay (per tile)
          if (riveArtBoard != null && showAnimation)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: showAnimation ? 1 : 0,
                child: Rive(
                  artboard: riveArtBoard!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
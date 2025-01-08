import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_walls/pages/wallpaper_detail_screen.dart';

class WallpaperTile extends StatelessWidget {
  final String imageUrl;
  final int index;
  final double extent;

  const WallpaperTile(
      {super.key,
      required this.imageUrl,
      required this.index,
      required this.extent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WallpaperDetailPage(
                    imageUrl: imageUrl, tag: index.toString())));
      },
      child: Hero(
        tag: index.toString(),
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            height: extent,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context,url) => const Center(child: CircularProgressIndicator.adaptive(),),
            )),
      ),
    );
  }
}

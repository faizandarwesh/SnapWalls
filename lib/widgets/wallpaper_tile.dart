import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        height: extent,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ));
  }
}

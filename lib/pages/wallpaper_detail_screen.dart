import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallpaperDetailPage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const WallpaperDetailPage({
    Key? key,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.save))
        ],
      ),
      body: Center(
        child: Hero(
          tag: tag, // Use the same tag as in WallpaperTile
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

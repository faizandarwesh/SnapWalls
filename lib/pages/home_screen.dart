import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:snap_walls/services/wallpaper_api_service.dart';
import 'package:snap_walls/widgets/wallpaper_tile.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) isScrolling;

  const HomeScreen({super.key, required this.isScrolling});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          _isVisible = false;
          widget.isScrolling(_isVisible);
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          _isVisible = true;
          widget.isScrolling(_isVisible);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, isInnerBoxScrolling) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.grey, shape: BoxShape.circle),
                ),
                bottom: const TabBar(
                    indicatorColor: Colors.purple,
                    indicatorWeight: 4,
                    tabs: [
                      Tab(text: "Favorites"),
                      Tab(text: "Like"),
                      Tab(
                        text: "Library",
                      )
                    ]),
              )
            ];
          },
          body: TabBarView(
            children: [
              //Tab 1 : Wallpapers Grid
              FutureBuilder(
                  future: WallpaperApiService().fetchWallpapers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong!!!"),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final photos = snapshot.data!;
                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.all(12),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          return WallpaperTile(
                            imageUrl: photo.url,
                            index: index,
                            extent: (index % 2) == 0 ? 300 : 150,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No Wallpaper found"),
                      );
                    }
                  }),
              //Tab 2 : Liked View
               const SizedBox(),

              //Tab 3 : Library View
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

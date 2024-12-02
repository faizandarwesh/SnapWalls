import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    _scrollController.addListener((){
      if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible){
          _isVisible = false;
          widget.isScrolling(_isVisible);
        }
      }

      if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
        if(!_isVisible){
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
                  Tab(text: "Suggestions"),
                  Tab(text: "Like"),
                  Tab(text: "Library",)
                ]),
              )
            ];
          },
          body: TabBarView(
            children: [
              //Tab 1 : Wallpapers Grid
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return WallpaperTile(
                    imageUrl: "https://picsum.photos/500/500?random=$index",
                    index: index,
                    extent: (index % 2) == 0 ? 300 : 150,
                  );
                },
              ),
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

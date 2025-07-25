import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rive/rive.dart' as rive;
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
  final ScrollController _gridViewScrollController = ScrollController();
  final apiService = WallpaperApiService();

  List<String> categories = [
    'new',
    'trending',
    'nature',
    'abstract',
    'animals',
  ];
  String selectedCategory = 'nature';
  List photos = [];
  bool isLoading = false;
  bool hasMore = true;

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

    _gridViewScrollController.addListener(_onScroll);
    _fetchWallpapers(reset: true);
  }

  void _onScroll() {
    if (_gridViewScrollController.position.pixels >=
        _gridViewScrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        _fetchWallpapers();
      }
    }
  }

  void _fetchWallpapers({bool reset = false}) async {
    setState(() {
      isLoading = true;
      if (reset) hasMore = true;
    });
    try {
      final newPhotos = await apiService.fetchWallpapers(
        category: selectedCategory,
        reset: reset,
      );
      setState(() {
        if (reset) {
          photos = newPhotos;
        } else {
          photos.addAll(newPhotos.skip(photos.length));
        }
        hasMore = newPhotos.length >= apiService.perPage;
      });
    } catch (e) {
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onCategorySelected(String category) {
    if (category != selectedCategory) {
      setState(() {
        selectedCategory = category;
      });
      _fetchWallpapers(reset: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _gridViewScrollController.dispose();
    super.dispose();
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
                title: SizedBox(
                  width: 75,
                  height: 75,
                  child: Image.asset("assets/images/logo_text.png"),
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
          body: Column(
            children: [
              // Category chips
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return ChoiceChip(
                      label: Text(cat[0].toUpperCase() + cat.substring(1)),
                      selected: selectedCategory == cat,
                      onSelected: (_) => _onCategorySelected(cat),
                    );
                  },
                ),
              ),
              // Wallpapers grid
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (isLoading && photos.isEmpty) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else if (photos.isEmpty) {
                      return const Center(child: Text("No Wallpaper found"));
                    }
                    return MasonryGridView.count(
                      controller: _gridViewScrollController,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: const EdgeInsets.all(12),
                      itemCount: photos.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == photos.length) {
                          return const Center(child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator.adaptive(),
                          ));
                        }
                        final photo = photos[index];
                        return WallpaperTile(
                          id: photo.id,
                          imageUrl: photo.url,
                          index: index,
                          extent: (index % 2) == 0 ? 300 : 150,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

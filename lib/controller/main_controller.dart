import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class MainController extends GetxController {

  Rx<Artboard?> riveArtBoard = Rx<Artboard?>(null);  // Stores the loaded artboard
  RxBool showAnimation = false.obs;
  late SMIBool likeInput; // StateMachine input for animation
  RxList<String> favoriteList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRiveFile(); // Load Rive when the controller initializes
  }

  // Load the Rive file and initialize the StateMachineController
  void _loadRiveFile() async {
    final data = await rootBundle.load('assets/raw/favorite.riv');
    await RiveFile.initialize();
    final file = RiveFile.import(data);
    final artBoard = file.mainArtboard;

    final controller =
    StateMachineController.fromArtboard(artBoard, 'State Machine 1'); // Replace with your state machine name
    if (controller != null) {
      artBoard.addController(controller);
      likeInput = controller.findInput<bool>('Like') as SMIBool; // Find 'like' input
    }
    riveArtBoard.value = artBoard; // Assign the loaded artBoard
  }

  // Toggle the like state
  // Show the animation for 2-3 seconds
    void toggleFavorite(String imageUrl, RxBool isFavorite) {
    if(favoriteList.contains(imageUrl)){
      favoriteList.remove(imageUrl);
      print("Removed: $imageUrl");
    }
    else{
      favoriteList.add(imageUrl);
      isFavorite.value = true;
      print("Added: $imageUrl");
    }

    if (likeInput != null) {
      likeInput.value = true; // Trigger the animation
    }

    showAnimation.value = true; // Show animation on the tile

    // Hide animation after 2-3 seconds
    Timer(const Duration(seconds: 3), () {
      showAnimation.value = false; // Hide animation
    });

    print("Current List: $favoriteList");
  }
}

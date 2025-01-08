import 'package:flutter/material.dart';
import 'package:snap_walls/camera/ui/camera_screen.dart';

class TakePhotoScreen extends StatelessWidget {
  const TakePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center Circular Camera Button
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple Effect Circle
                ...List.generate(3, (index) {
                  return Container(
                    width: 180 - (index * 20),
                    height: 180 - (index * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurpleAccent.withOpacity(0.1 * (3 - index)),
                    ),
                  );
                }),
                // Camera Icon Button
                GestureDetector(
                  onTap: () {
                    // Action for taking a photo
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CameraScreen()));

                    print('Take a photo');
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Text: Smart ID Photo
          const Text(
            'Take your photo',
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'A very efficient photo shooting tool',
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

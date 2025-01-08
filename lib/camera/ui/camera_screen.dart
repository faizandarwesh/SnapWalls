import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:snap_walls/camera/ui/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras!.first,
      ResolutionPreset.high,
    );
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller != null && _controller!.value.isInitialized
          ? Stack(
        children: [
          CameraPreview(_controller!), // Live camera feed
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _capturePhoto,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _capturePhoto() async {
    final image = await _controller!.takePicture();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(imagePath: image.path),
      ),
    );
  }
}

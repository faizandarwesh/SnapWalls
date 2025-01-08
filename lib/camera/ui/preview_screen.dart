import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  const PreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final List<Widget> _overlays = [];
  ColorFilter? _colorFilter;

  // Function to add text to the image
  void _addText() {
    setState(() {
      _overlays.add(
        DraggableText(
          initialPosition: const Offset(100, 100),
          text: "Your Text",
        ),
      );
    });
  }

  // Function to add an image filter (like glasses/hat)
  void _addFilter(String assetPath) {
    setState(() {
      _overlays.add(
        DraggableImage(
          assetPath: assetPath,
          initialPosition: const Offset(150, 150),
        ),
      );
    });
  }

  // Function to set a color filter on the photo
  void _setColorFilter(Color color) {
    setState(() {
      _colorFilter = ColorFilter.mode(color, BlendMode.color);
    });
  }

  @override
  Widget build(BuildContext context) {

    print(widget.imagePath);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Photo")),
      body: Stack(
        children: [
          // Main Image with Color Filter
          ColorFiltered(
            colorFilter: _colorFilter ?? const ColorFilter.mode(Colors.transparent, BlendMode.clear),
            child: Center(
              child: Image.network("https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            ),
          ),

          // Overlays (Text and Filters)
          ..._overlays,

          // Add control buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Wrap(
              children: [
                ElevatedButton.icon(
                  onPressed: _addText,
                  icon: const Icon(Icons.text_fields),
                  label: const Text("Add Text"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addFilter("assets/images/hat.jpg"),
                  icon: const Icon(Icons.filter_vintage),
                  label: const Text("Add Hat"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addFilter("assets/images/glasses.jpg"),
                  icon: const Icon(Icons.face),
                  label: const Text("Add Glasses"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _setColorFilter(Colors.blue.withOpacity(0.3)),
                  icon: const Icon(Icons.color_lens),
                  label: const Text("Blue Filter"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for draggable text
class DraggableText extends StatefulWidget {
  final Offset initialPosition;
  final String text;

  const DraggableText({
    Key? key,
    required this.initialPosition,
    required this.text,
  }) : super(key: key);

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}

// Widget for draggable image filters (like hat/glasses)
class DraggableImage extends StatefulWidget {
  final Offset initialPosition;
  final String assetPath;

  const DraggableImage({
    Key? key,
    required this.initialPosition,
    required this.assetPath,
  }) : super(key: key);

  @override
  _DraggableImageState createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Image.asset(
          widget.assetPath,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}

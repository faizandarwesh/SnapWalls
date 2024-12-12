import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_walls/services/wallpaper_api_service.dart';

class WallpaperDetailPage extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const WallpaperDetailPage({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  State<WallpaperDetailPage> createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  String downloadMessage = "DOWNLOADING...";
  bool isDownloadingStart = false;
  double percentage = 0.0;
  double _percentage = 0.0;

  static const serviceMethodChannel =  MethodChannel("DownloadServiceChannel");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: widget.tag, // Use the same tag as in WallpaperTile
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 8,
              right: 16,
              child: SafeArea(
                child: FloatingActionButton(
                    child: const Icon(
                      Icons.download,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      downloadWallpaper();
                    }),
              )),
          Positioned(
              top: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 250,
                    height: 80,
                    child: ElevatedButton(onPressed: () async{
                      await serviceMethodChannel.invokeMethod("startForegroundService");
                    }, child: const Text("Start")),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    width: 250,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(onPressed: () async{
                     await serviceMethodChannel.invokeMethod("stopForegroundService");
                    }, child: const Text("Stop")),
                  ),
                ],
              )),
          Positioned(
              bottom: 8,
              right: 8,
              child: FloatingActionButton(
                  child: const Icon(Icons.settings),
                  onPressed: () async {
                    const platform = MethodChannel('versionChannel');
                    final platformVersion =
                        await platform.invokeMethod('getPlatformVersion');
                    print("platformVersion : $platformVersion");
                  })),
          if (isDownloadingStart) ...[
            Positioned(
                top: 150,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Download message
                    Text(
                      downloadMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                    const SizedBox(height: 16),

                    // Progress indicator with percentage
                    Stack(
                      children: [
                        // Outer container for border and background
                        Container(
                          width: double.infinity,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                          ),
                        ),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: LinearProgressIndicator(
                            value: _percentage,
                            minHeight: 30,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.purple),
                            backgroundColor: Colors.transparent,
                          ),
                        ),

                        // Percentage text
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              "${(_percentage * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ]
        ],
      ),
    );
  }

  downloadWallpaper() async {
    if (await requestStoragePermission()) {
      var directory = await getApplicationSupportDirectory();

      Dio dio = Dio();
      dio.download(
          "https://www.sample-videos.com/img/Sample-png-image-30mb.png",
          "${directory.path}/sample.jpg",
          onReceiveProgress: (actualBytes, totalBytes) {
        if (totalBytes > 0) {
          percentage = (actualBytes / totalBytes) * 100;
          _percentage = percentage / 100;

          setState(() {
            isDownloadingStart = true;
            /*downloadMessage =
                "Downloading... ${percentage.toStringAsFixed(0)} : %";*/
          });
          print("Downloading...  ${percentage.toStringAsFixed(0)} : %");
        }
        print("Path : ${directory.path}");
        print("nothing");
      });
    } else {
      print("Permission not granted");
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }
}

import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  late InterstitialAd _interstitialAd;
  bool isInterstitialAdLoaded = false;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late String taskId;

  static const serviceMethodChannel = MethodChannel("DownloadServiceChannel");

  @override
  void initState() {
    _initBannerAd();
    _initInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: widget.tag, // Use the same tag as in WallpaperTile
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
              top: 8,
              right: 16,
              child: SafeArea(
                child: FloatingActionButton(
                    heroTag: null,
                    child: const Icon(
                      Icons.cloud_download_outlined,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      downloadWallpaperShowingNotification(
                          widget.imageUrl);
                      //downloadWallpaper();
                    }),
              )),
          // Positioned(
          //     top: 8,
          //     right: 16,
          //     child: SafeArea(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           FloatingActionButton(
          //               heroTag: null,
          //               child: const Icon(
          //                 Icons.cloud_download_outlined,
          //                 color: Colors.purple,
          //               ),
          //               onPressed: () {
          //                 downloadWallpaperShowingNotification(
          //                     widget.imageUrl);
          //                 //downloadWallpaper();
          //               }),
          //           const SizedBox(width: 16,),
          //           FloatingActionButton(
          //               heroTag: null,
          //               child: const Icon(
          //                 Icons.slideshow_outlined,
          //                 color: Colors.purple,
          //               ),
          //               onPressed: () {
          //                 FlutterDownloader.open(taskId: taskId);
          //                 //downloadWallpaper();
          //               }),
          //         ],
          //       ),
          //     )),
       /*   Positioned(
              top: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          // Button background color
                          foregroundColor: Colors.white,
                          // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Slightly rounded corners
                          ),
                          elevation: 5,
                          // Shadow effect for a better look
                          padding: const EdgeInsets.all(
                              16), // Inner padding for better spacing
                        ),
                        onPressed: () async {
                          await serviceMethodChannel
                              .invokeMethod("startForegroundService");
                        },
                        child: const Text("Start Foreground Service")),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          // Button background color
                          foregroundColor: Colors.white,
                          // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Slightly rounded corners
                          ),
                          elevation: 5,
                          // Shadow effect for a better look
                          padding: const EdgeInsets.all(
                              16), // Inner padding for better spacing
                        ),
                        onPressed: () async {
                          await serviceMethodChannel
                              .invokeMethod("stopForegroundService");
                        },
                        child: const Text("Stop Foreground Service")),
                  ),
                ],
              )),
          Positioned(
              bottom: 200,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 75,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      // Button background color
                      foregroundColor: Colors.white,
                      // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Slightly rounded corners
                      ),
                      elevation: 5,
                      // Shadow effect for a better look
                      padding: const EdgeInsets.all(
                          16), // Inner padding for better spacing
                    ),
                    onPressed: () async {
                      if (isInterstitialAdLoaded) {
                        _interstitialAd.show();
                      }
                    },
                    child: const Text("InterstitialAd")),
              )),
          Positioned(
              bottom: 70,
              right: 8,
              child: FloatingActionButton(
                  heroTag: null,
                  child: const Icon(Icons.settings),
                  onPressed: () async {
                    const platform = MethodChannel('versionChannel');
                    final platformVersion =
                        await platform.invokeMethod('getPlatformVersion');
                    debugPrint("platformVersion : $platformVersion");
                  })),*/
          if (_isAdLoaded) ...[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd)),
            ),
          ],
         /* if (isDownloadingStart) ...[
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
          ]*/
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
          debugPrint("Downloading...  ${percentage.toStringAsFixed(0)} : %");
        }
        debugPrint("Path : ${directory.path}");
        debugPrint("nothing");
      });
    } else {
      debugPrint("Permission not granted");
    }
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: const AdRequest());

    _bannerAd.load();
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded, onAdFailedToLoad: (error) {}));
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    isInterstitialAdLoaded = true;
  }

  void downloadWallpaperShowingNotification(String url) async {

    String fileName = 'file_${Random().nextInt(100000)}.jpeg';
    var directory = await getApplicationSupportDirectory();

     await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      fileName: fileName,
      // Optional: define a filename
      showNotification: true,
      // Optional: show a notification with progress
      openFileFromNotification: true, // Optional: open the file when tapped
    ).then((value) => taskId = value!);


    debugPrint('Download task id: $taskId');

 //  FlutterDownloader.pause(taskId: taskId!);

   /* FlutterDownloader.resume(taskId: taskId!);

    FlutterDownloader.open(taskId: taskId);*/

  }
}

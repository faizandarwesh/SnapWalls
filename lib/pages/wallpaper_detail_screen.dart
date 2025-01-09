import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';

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

  late InterstitialAd _interstitialAd;
  bool isInterstitialAdLoaded = false;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late String taskId;

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
                      if (isInterstitialAdLoaded) {
                        _interstitialAd.show();
                      }
                      downloadWallpaper(widget.imageUrl);
                    }),
              )),
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
        ],
      ),
    );
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

  void downloadWallpaper(String url) async {
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
  }
}

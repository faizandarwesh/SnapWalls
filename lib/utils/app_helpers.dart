import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

/// A helper class that manages app initialization tasks
class AppHelpers {
  /// Loads environment variables
  static Future<void> initializeDotEnv() async {
    await dotenv.load(fileName: ".env");
  }

  /// Initializes Mobile Ads
  static Future<void> initializeMobileAds() async {
    MobileAds.instance.initialize();
  }

  /// Initializes Flutter Downloader
  static Future<void> initializeFlutterDownloader() async {
    await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true,
    );
  }

  /// Requests notification permissions
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}

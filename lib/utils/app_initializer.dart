// helpers/app_initializer.dart

import 'package:snap_walls/utils/app_helpers.dart';

/// Central class for app initialization tasks
class AppInitializer {
  static Future<void> initialize() async {
    await AppHelpers.initializeDotEnv();
    await AppHelpers.initializeMobileAds();
    await AppHelpers.initializeFlutterDownloader();
    await AppHelpers.requestNotificationPermission();
  }
}

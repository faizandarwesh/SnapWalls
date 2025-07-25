import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_walls/controller/main_controller.dart';
import 'package:snap_walls/pages/landing_screen.dart';
import 'package:snap_walls/theme/theme_provider.dart';
import 'package:snap_walls/utils/app_initializer.dart';
import 'package:get/get.dart';
import 'onboarding/ui/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app services and configurations
  await AppInitializer.initialize();

  // Check if onboarding is completed
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = !(prefs.getBool('onboarding_done') ?? false);
  Get.put(MainController());

  runApp(ProviderScope(child: MyApp(showOnboarding: true)));
}

class MyApp extends ConsumerWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'SnapWalls',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: showOnboarding ? const OnboardingScreen() : const LandingScreen(),
      routes: {
        '/home': (context) => const LandingScreen(), // Add this line
      },
    );

  }
}

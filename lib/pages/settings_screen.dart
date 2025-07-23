import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:snap_walls/utils/app_helpers.dart';

import '../theme/theme_provider.dart';
import '../utils/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
   SettingsScreen({super.key});

  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xff1f1f1f),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'App',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Settings',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                decoration:  BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ListView(
                    children: [
                      _buildSettingCard(
                          context,
                          Icons.star_border_outlined,
                          'Rate the application',
                          'Your feedback is important', () async {
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      }),
                      _buildSettingCard(
                          context,
                          Icons.share_outlined,
                          'Share with friends',
                          'Tell your friends if you like it', () {
                        AppHelpers.shareAppLink();
                      }),
                      _buildSettingCard(
                          context,
                          Icons.email_outlined, 'Contact Us',
                          "Any questions? We'll help", () {
                        _modalBottomSheetMenu(
                            context, 'Contact Us', AppConstants.dummyText);
                      }),
                      _buildSettingCard(
                          context,
                          Icons.security, 'Privacy Policy', 'More about safety',
                          () {
                        _modalBottomSheetMenu(
                            context, 'Privacy Policy', AppConstants.dummyText);
                      }),
                      _buildSettingCard(
                          context,
                          Icons.sunny, 'Theme',
                          'Choose your preference', () {}, true,themeMode,themeNotifier),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _modalBottomSheetMenu(BuildContext context, String title, String content) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Allows the bottom sheet to expand to fit the content
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        // Prevents the bottom sheet from taking up the full screen by default
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              // Allows scrolling when the content is larger
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "For more information, please contact us at support@example.com or call us at +1-234-567-890.",
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildSettingCard(
    BuildContext context,IconData icon, String title, String subtitle, VoidCallback onPress,
    [bool isSwitch = false,themeMode, themeNotifier]) {
  return GestureDetector(
    onTap: onPress,
    child: Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Theme.of(context).iconTheme.color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: isSwitch
            ? CupertinoSwitch(
          value: themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeNotifier.setTheme(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        )
            : const SizedBox(),
      ),
    ),
  );
}

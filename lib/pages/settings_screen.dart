import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
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
                decoration: const BoxDecoration(
                  color: Color(0xfff6f5fb),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ListView(
                    children: [
                      _buildSettingCard(
                          Icons.star_border_outlined,
                          'Rate the application',
                          'Your feedback is important', () async {
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      }),
                      _buildSettingCard(
                          Icons.share_outlined,
                          'Share with friends',
                          'Tell your friends if you like it',
                          () {}),
                      _buildSettingCard(Icons.email_outlined, 'Contact Us',
                          "Any questions? We'll help", () {}),
                      _buildSettingCard(Icons.security, 'Privacy Policy',
                          'More about safety', () {}),
                      _buildSettingCard(Icons.sunny, 'Theme',
                          'Choose your preference', () {}, true),
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

Widget _buildSettingCard(
    IconData icon, String title, String subtitle, VoidCallback onPress,
    [bool isSwitch = false]) {
  return GestureDetector(
    onTap: onPress,
    child: Card(
      color: const Color(0xffffffff),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
          leading: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                  color: Color(0xfff2f3f5),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Icon(icon, color: Colors.black)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          trailing: isSwitch
              ? CupertinoSwitch(
                  activeColor: const Color(0xfff2f3f5),
                  value: true, // Here, you can bind it to a theme state
                  onChanged: (value) {
                    // Handle theme switching logic
                  },
                )
              : const SizedBox()),
    ),
  );
}

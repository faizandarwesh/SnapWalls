import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingPages = [
    {
      'image':
          'https://images.pexels.com/photos/7130466/pexels-photo-7130466.jpeg',
      'title': 'Stunning Wallpapers',
      'subtitle': 'Browse thousands of high-quality wallpapers from Pexels.',
    },
    {
      'image':
          'https://images.pexels.com/photos/7130561/pexels-photo-7130561.jpeg',
      'title': 'Save Your Favorites',
      'subtitle': 'Mark and revisit your favorite wallpapers anytime.',
    },
    {
      'image':
          'https://images.pexels.com/photos/7130481/pexels-photo-7130481.jpeg',
      'title': 'Daily Inspiration',
      'subtitle': 'Get fresh new wallpapers daily to refresh your device.',
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    Navigator.of(context).pushReplacementNamed('/home'); // or your home route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingPages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              final page = onboardingPages[index];
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(page['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Center(
                              child:
                                  Image.asset("assets/images/logo_text.png"))),
                      Text(
                        page['title']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        page['subtitle']!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _finishOnboarding,
                            child: const Text(
                              'Skip',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            children: List.generate(
                              onboardingPages.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentIndex == i ? 12 : 8,
                                height: _currentIndex == i ? 12 : 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == i
                                      ? Colors.white
                                      : Colors.white38,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          if (_currentIndex == onboardingPages.length - 1)
                            ElevatedButton(
                              onPressed: _finishOnboarding,
                              child: const Text('Get Started'),
                            )
                          else
                            const SizedBox(width: 100), // spacing filler
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

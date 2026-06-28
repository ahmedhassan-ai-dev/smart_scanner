import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/onboarding_illustrations.dart';
import '../home_screen.dart';

class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({super.key});

  Future<void> _completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_intro', true);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,

      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),

      onSkip: () async {
        await _completeIntro(context);
      },

      next: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xff2563EB),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 18,
        ),
      ),

      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff2563EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "Get Started",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),

      onDone: () async {
        await _completeIntro(context);
      },

      dotsDecorator: DotsDecorator(
        activeColor: const Color(0xff2563EB),
        size: const Size(10, 10),
        activeSize: const Size(24, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),

      pages: [
        PageViewModel(
          titleWidget: const Text(
            "Scan Documents\nInstantly",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Capture documents with AI-powered edge detection for perfect scans every time.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
          ),

          image: Container(
            margin: const EdgeInsets.only(top: 40),
            child: const ScanIllustration(),
          ),
        ),

        PageViewModel(
          titleWidget: const Text(
            "Smart Filters",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Enhance readability using intelligent document filters powered by machine learning.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
          ),

          image: Container(
            margin: const EdgeInsets.only(top: 40),
            child: const FiltersIllustration(),
          ),
        ),

        PageViewModel(
          titleWidget: const Text(
            "Create PDFs",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Combine multiple pages and export high-quality PDFs instantly.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
          ),

          image: Container(
            margin: const EdgeInsets.only(top: 40),
            child: const PdfIllustration(),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'intro/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    final seenIntro = prefs.getBool('seen_intro') ?? false;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            seenIntro ? const HomeScreen() : const IntroductionScreenPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2- استخدام لون التطبيق الأساسي من الـ Theme
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      // 8- استخدام SafeArea للتوافق مع جميع الشاشات
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // 9- استخدام Spacer لدفع المحتوى للوسط
              const Spacer(),

              // 1- أنيميشن احترافي للوجو (Scale & Fade)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    // 3- تحسين شكل كارت اللوجو والظل
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        // 4- أيقونة أحدث
                        Icons.document_scanner_rounded,
                        size: 72,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 5- تنسيق عنوان التطبيق الجديد
                    const Text(
                      "Smart Scanner",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 6- الوصف الأنيق والمختصر
                    const Text(
                      "Scan • Enhance • Export",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        letterSpacing: .3,
                      ),
                    ),
                  ],
                ),
              ),

              // 9- استخدام Spacer لدفع الـ Loading للأسفل
              const Spacer(),

              // 7- تحسين شكل الـ Loading وإضافة نص توضيحي
              const Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.8,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Preparing your workspace...",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
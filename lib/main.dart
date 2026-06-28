import 'package:flutter/material.dart';
import 'features/history/data/history_service.dart';
import 'screens/intro/introduction_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HistoryService.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Scanner',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff2563EB),
        useMaterial3: true,
      ),
      home: const IntroductionScreenPage(),
    );
  }
}
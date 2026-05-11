import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/utils/app_theme.dart';
import 'package:frontend/screens/splash_screen.dart';

void main() {
  runApp(const GeoPunchApp());
}

class GeoPunchApp extends StatelessWidget {
  const GeoPunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GeoPunch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

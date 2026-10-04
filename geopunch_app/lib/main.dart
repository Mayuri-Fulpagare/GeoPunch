import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geopunch_app/core/theme/app_theme.dart';
import 'package:geopunch_app/features/auth/screens/splash_screen.dart';

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

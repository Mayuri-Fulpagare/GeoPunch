import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/view/login_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
        fontFamily: 'Inter', // We can change this later
      ),
      home: const LoginScreen(),
    );
  }
}

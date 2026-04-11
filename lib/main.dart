import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/views/home_view.dart';
import 'package:clincal/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/auth/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // It's better to manage this via the MaterialApp theme to prevent unexpected overrides.
  // But we can still keep this as a base fallback.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Let the app background show through
      statusBarIconBrightness: Brightness.light, // White icons for Android
      statusBarBrightness: Brightness.dark, // White icons for iOS
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: appColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Ensures transparent status bar inside Scaffolds
            statusBarIconBrightness: Brightness.light, 
            statusBarBrightness: Brightness.dark, 
          ),
        ),
      ),
      home: const Root(),
    );
  }
}


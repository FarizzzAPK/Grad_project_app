import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  
  bool isLoggedIn = false;
  final token = await AuthService.instance.getToken();
  if (token != null && token.isNotEmpty) {
    if (await AuthService.instance.isTokenExpired()) {
      final newToken = await AuthService.instance.refreshAccessToken();
      if (newToken != null) {
        isLoggedIn = true;
      } else {
        await AuthService.instance.clearAuth();
      }
    } else {
      isLoggedIn = true;
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: appColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: isLoggedIn ? const Root() : const LoginView(),
    );
  }
}

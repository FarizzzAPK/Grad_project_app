import 'package:clincal/features/home/views/home_view.dart';
import 'package:clincal/root.dart';
import 'package:flutter/material.dart';

import 'features/auth/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Root(),
    );
  }
}


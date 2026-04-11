import 'dart:math';

import 'package:clincal/features/medication/views/medication_view.dart';
import 'package:clincal/features/profile/views/profile_view.dart';
import 'package:clincal/features/requests/views/requests_view.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'features/home/views/home_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  AppColors appColors = AppColors();
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeView(),
    MedicationView(),
    RequestsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: "Medication",
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: -pi / 4,
              child: const Icon(Icons.send),
            ),
            label: "Requests",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// lib/view/bottom_navigation/bottom_navigation_state.dart (Updated)

import 'package:flutter/material.dart';
import 'package:motofix_app/feature/auth/presentation/view/profile_screen.dart';
import 'package:motofix_app/view/activities_screen.dart';
import 'package:motofix_app/view/history_screen.dart';
import 'package:motofix_app/view/home_screen.dart';

class BottomNavigationState {
  final int currentIndex;

  // The list of screens is now just a plain list of widgets.
  // NO BlocProviders here.
  final List<Widget> screens = const [
    HomeScreen(),
    ActivitiesScreen(),
    HistoryScreen(),
    ProfileViewPage(),
  ];

  BottomNavigationState({required this.currentIndex});

  Widget get currentScreen => screens[currentIndex];
}
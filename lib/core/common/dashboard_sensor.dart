import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/cubit/bottom_navigation_cubit.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A dedicated class to handle gyroscope logic for dashboard navigation.
class DashboardGyroHandler {
  final BuildContext context;

  // Private subscription and flag for gyroscope logic.
  StreamSubscription? _gyroSub;
  bool _gyroTriggered = false;

  DashboardGyroHandler({
    required this.context,
  });

  /// Starts listening to the gyroscope event stream.
  void startListening() {
    _gyroSub = gyroscopeEvents.listen(_onGyroscope);
  }

  /// Disposes of the stream subscription to prevent memory leaks.
  void dispose() {
    _gyroSub?.cancel();
  }

  /// Handles rotation events from the gyroscope to switch tabs.
  void _onGyroscope(GyroscopeEvent event) {
    const rotationThreshold = 4.0;

    // Check for a rapid rotation and ensure the trigger is not on cooldown.
    if (!_gyroTriggered &&
        (event.x.abs() > rotationThreshold ||
            event.y.abs() > rotationThreshold)) {
      _gyroTriggered = true; // Set debounce flag to prevent multiple triggers

      // Access the navigation cubit from the context.
      final cubit = context.read<BottomNavigationCubit>();
      final currentIndex = cubit.state;
      const screenCount = 4; // The total number of tabs.
      final nextIndex = (currentIndex + 1) % screenCount;

      // Command the cubit to change the tab.
      cubit.changeTab(nextIndex);

      // Provide visual feedback to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switched to next tab!'),
          duration: Duration(seconds: 1),
        ),
      );

      // Reset the debounce flag after a 1.5-second cooldown period.
      Future.delayed(const Duration(milliseconds: 1500), () {
        _gyroTriggered = false;
      });
    }
  }
}

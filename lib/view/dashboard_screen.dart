// lib/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/dashboard_sensor.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:motofix_app/feature/booking/presentation/view/booking_view.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
import 'package:motofix_app/view/history_screen.dart';
import 'package:motofix_app/feature/auth/presentation/view/profile_screen.dart';
import 'package:motofix_app/view/home_screen.dart';

import '../app/cubit/bottom_navigation_cubit.dart';
import '../app/service_locator/service_locator.dart';

/// This is the main Dashboard widget.
/// Its only job is to provide all the necessary BLoCs/Cubits to the widget tree.
class MotoFixDashboard extends StatelessWidget {
  const MotoFixDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavigationCubit()),
        BlocProvider.value(value: serviceLocator<ServiceViewModel>()),
        BlocProvider.value(value: serviceLocator<BookingViewModel>()),
        BlocProvider.value(value: serviceLocator<ProfileViewModel>()),
      ],
      // The child is the new stateful view that will handle the sensor.
      child: const _DashboardView(),
    );
  }
}

/// This is the private, stateful widget that builds the UI and manages
/// the sensor handler's lifecycle.
class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => __DashboardViewState();
}

class __DashboardViewState extends State<_DashboardView> {
  // NEW: A reference to our sensor handler.
  late final DashboardGyroHandler _gyroHandler;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const BookingView(),
    const HistoryScreen(),
    const ProfileViewPage(),
  ];

  @override
  void initState() {
    super.initState();
    // NEW: Initialize the handler in initState, passing the widget's context.
    // This context has access to the providers from MultiBlocProvider.
    _gyroHandler = DashboardGyroHandler(context: context);
    _gyroHandler.startListening();
  }

  @override
  void dispose() {
    // NEW: Cleanly dispose of the handler to stop listening to the sensor.
    _gyroHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The UI is built by listening to the navigation cubit.
    return BlocBuilder<BottomNavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          backgroundColor: const Color(0xFF2A4759),
          body: IndexedStack(
            index: selectedIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, selectedIndex),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF2A4759),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      currentIndex: selectedIndex,
      onTap: (index) {
        // When a tab is tapped manually, we still use the cubit to change the state.
        context.read<BottomNavigationCubit>().changeTab(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              FontAwesomeIcons.history), // Use a different icon for clarity
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

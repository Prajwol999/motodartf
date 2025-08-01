// lib/feature/home/presentation/view/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/core/common/app_colors.dart'; // Adjust import path
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';

// Import your new widget files
import '../feature/customer_service/presentation/view/home_app_bar.dart';
import '../feature/customer_service/presentation/view/main_cta_card.dart';
import '../feature/customer_service/presentation/view/quick_service_section.dart';
import '../feature/customer_service/presentation/view/recent_activity.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ServiceViewModel>().add(GetAllServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryDark,
      // Using a custom AppBar widget makes the Scaffold body cleaner
      appBar: HomeAppBar(),
      body: SafeArea(
        // Remove the top padding from SafeArea as the AppBar handles it
        top: false,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // The AppBar is now outside the scroll view, which is better practice.
                // We add space to compensate for the app bar's removal from the column.
                SizedBox(height: 10),
                MainCtaCard(),
                SizedBox(height: 30),
                QuickServicesSection(),
                SizedBox(height: 30),
                RecentActivitySection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
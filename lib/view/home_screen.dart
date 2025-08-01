import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/feature/customer_service/presentation/view/home_app_bar.dart';
import 'package:motofix_app/feature/customer_service/presentation/view/recent_activity.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';


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
    return Scaffold(
      backgroundColor: AppColors.neutralBlack,
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const MainCtaCard(),
                    const SizedBox(height: 32),
                    const QuickServicesSection(),
                    const SizedBox(height: 32),
                    const RecentActivitySection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

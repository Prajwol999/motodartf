// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:motofix_app/core/common/app_colors.dart';
// import 'package:motofix_app/core/common/dashboard_sensor.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
// import 'package:motofix_app/feature/booking/presentation/view/booking_view.dart';
// import 'package:motofix_app/feature/booking/presentation/view/complete_history/complete_history_page.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
// import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';
// import 'package:motofix_app/view/history_screen.dart';
// import 'package:motofix_app/feature/auth/presentation/view/profile_screen.dart';
// import 'package:motofix_app/view/home_screen.dart';

// import '../app/cubit/bottom_navigation_cubit.dart';
// import '../app/service_locator/service_locator.dart';

// /// This is the main Dashboard widget.
// /// Its only job is to provide all the necessary BLoCs/Cubits to the widget tree.
// class MotoFixDashboard extends StatelessWidget {
//   const MotoFixDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => BottomNavigationCubit()),
//         BlocProvider.value(value: serviceLocator<ServiceViewModel>()),
//         BlocProvider.value(value: serviceLocator<BookingViewModel>()),
//         BlocProvider.value(value: serviceLocator<ProfileViewModel>()),
//         BlocProvider.value(value: serviceLocator<BookingHistoryBloc>()) ,
//          BlocProvider.value(value: serviceLocator<ReviewBloc>()) ,

//       ],
//       child: const _DashboardView(),
//     );
//   }
// }

// class _DashboardView extends StatefulWidget {
//   const _DashboardView();

//   @override
//   State<_DashboardView> createState() => __DashboardViewState();
// }

// class __DashboardViewState extends State<_DashboardView> {
//   late final DashboardGyroHandler _gyroHandler;

//   static final List<Widget> _widgetOptions = <Widget>[
//     const HomeScreen(),
//     const BookingView(),
//     const BookingHistoryPage(),
//     const ProfileViewPage(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _gyroHandler = DashboardGyroHandler(context: context);
//     _gyroHandler.startListening();
//   }

//   @override
//   void dispose() {
//     _gyroHandler.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavigationCubit, int>(
//       builder: (context, selectedIndex) {
//         return Scaffold(
//           backgroundColor: AppColors.neutralBlack,
//           body: IndexedStack(
//             index: selectedIndex,
//             children: _widgetOptions,
//           ),
//           bottomNavigationBar:
//               _buildBottomNavigationBar(context, selectedIndex),
//         );
//       },
//     );
//   }

//   Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
//     return BottomNavigationBar(
//       backgroundColor: AppColors.neutralDark,
//       selectedItemColor: AppColors.brandPrimary,
//       unselectedItemColor: AppColors.textSecondary,
//       type: BottomNavigationBarType.fixed,
//       selectedLabelStyle: const TextStyle(
//         fontWeight: FontWeight.bold,
//         color: AppColors.brandPrimary,
//       ),
//       unselectedLabelStyle: const TextStyle(
//         fontWeight: FontWeight.w500,
//         color: AppColors.textSecondary,
//       ),
//       currentIndex: selectedIndex,
//       onTap: (index) {
//         context.read<BottomNavigationCubit>().changeTab(index);
//       },
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.local_activity),
//           label: 'Activities',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(FontAwesomeIcons.history),
//           label: 'History',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/core/common/dashboard_sensor.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:motofix_app/feature/booking/presentation/view/booking_view.dart';
import 'package:motofix_app/feature/booking/presentation/view/complete_history/complete_history_page.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';
import 'package:motofix_app/feature/chat/presentation/view/chat_screen.dart'; // Import chat screen
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';
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
        BlocProvider.value(value: serviceLocator<BookingHistoryBloc>()),
        BlocProvider.value(value: serviceLocator<ReviewBloc>()),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => __DashboardViewState();
}

class __DashboardViewState extends State<_DashboardView> {
  late final DashboardGyroHandler _gyroHandler;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const BookingView(),
    const BookingHistoryPage(),
    const ProfileViewPage(),
  ];

  @override
  void initState() {
    super.initState();
    _gyroHandler = DashboardGyroHandler(context: context);
    _gyroHandler.startListening();
  }

  @override
  void dispose() {
    _gyroHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          backgroundColor: AppColors.neutralBlack,
          body: IndexedStack(
            index: selectedIndex,
            children: _widgetOptions,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            backgroundColor: AppColors.brandPrimary,
            // CORRECTED: Added the 'child:' parameter
            child: const Icon(Icons.support_agent, color: Colors.white),
          ),
          bottomNavigationBar:
              _buildBottomNavigationBar(context, selectedIndex),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
    return BottomNavigationBar(
      backgroundColor: AppColors.neutralDark,
      selectedItemColor: AppColors.brandPrimary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.brandPrimary,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      currentIndex: selectedIndex,
      onTap: (index) {
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
          icon: Icon(FontAwesomeIcons.history),
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
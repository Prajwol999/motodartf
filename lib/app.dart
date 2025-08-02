

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:motofix_app/app/service_locator/service_locator.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
// import 'package:motofix_app/feature/splash/view/splash_page.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ FIX: Wrap MaterialApp with MultiBlocProvider to provide BLoCs globally
//     return MultiBlocProvider(
//       providers: [
//         // Provides LoginViewModel to the entire app
//         BlocProvider<LoginViewModel>(
//           create: (context) => serviceLocator<LoginViewModel>(),
//         ),
//         // Provides ServiceViewModel and immediately fetches all services at startup
//         BlocProvider<ServiceViewModel>(
//           create: (context) => serviceLocator<ServiceViewModel>()..add(GetAllServicesEvent()),
//         ),
//         // Provides BookingViewModel to the entire app
//         BlocProvider<BookingViewModel>(
//           create: (context) => serviceLocator<BookingViewModel>(),
//         ),
//         // Add any other global ViewModels/BLoCs here
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'MotoFix',
//         theme: ThemeData.dark().copyWith(
//           primaryColor: Colors.black,
//           scaffoldBackgroundColor: Colors.black,
//           inputDecorationTheme: const InputDecorationTheme(
//             labelStyle: TextStyle(color: Colors.white70),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white30),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               minimumSize: const Size.fromHeight(50),
//             ),
//           ),
//           textTheme: const TextTheme(
//             bodyMedium: TextStyle(
//               color: Colors.white70,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//             titleLarge: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//             bodySmall: TextStyle(
//               color: Colors.white60,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//           ),
//         ),
//         // SplashPage remains the home. It and all subsequent screens
//         // will now have access to the BLoCs provided above.
//         home: const SplashPage(),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:motofix_app/app/service_locator/service_locator.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
// import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';
// import 'package:motofix_app/feature/splash/view/splash_page.dart';

// // ⚠️ ACTION REQUIRED: Adjust this import path to where your ReviewBloc is located.


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Wrap MaterialApp with MultiBlocProvider to provide BLoCs to the entire widget tree.
//     return MultiBlocProvider(
//       providers: [
//         // Provides LoginViewModel to the entire app.
//         BlocProvider<LoginViewModel>(
//           create: (context) => serviceLocator<LoginViewModel>(),
//         ),
//         // Provides ServiceViewModel and immediately fetches all services at startup.
//         BlocProvider<ServiceViewModel>(
//           create: (context) => serviceLocator<ServiceViewModel>()..add(GetAllServicesEvent()),
//         ),
//         // Provides BookingViewModel to the entire app.
//         BlocProvider<BookingViewModel>(
//           create: (context) => serviceLocator<BookingViewModel>(),
//         ),
//         // ✅ FIX: Provide the ReviewBloc that was missing.
//         // This makes ReviewBloc available globally, fixing the "ProviderNotFoundError".
//         BlocProvider<ReviewBloc>(
//           create: (context) => serviceLocator<ReviewBloc>(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'MotoFix',
//         theme: ThemeData.dark().copyWith(
//           primaryColor: Colors.black,
//           scaffoldBackgroundColor: Colors.black,
//           inputDecorationTheme: const InputDecorationTheme(
//             labelStyle: TextStyle(color: Colors.white70),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white30),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               minimumSize: const Size.fromHeight(50),
//             ),
//           ),
//           textTheme: const TextTheme(
//             bodyMedium: TextStyle(
//               color: Colors.white70,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//             titleLarge: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//             bodySmall: TextStyle(
//               color: Colors.white60,
//               fontFamily: 'OpenSans', // Set global font
//             ),
//           ),
//         ),
//         // The SplashPage and all subsequent screens will now have access
//         // to all the BLoCs provided above, including ReviewBloc.
//         home: const SplashPage(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
import 'package:motofix_app/feature/splash/view/splash_page.dart';

// ⚠️ ACTION REQUIRED: Verify this import path matches the location of your ReviewBloc file.
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with MultiBlocProvider to provide BLoCs to the entire widget tree.
    return MultiBlocProvider(
      providers: [
        // Provides LoginViewModel to the entire app.
        BlocProvider<LoginViewModel>(
          create: (context) => serviceLocator<LoginViewModel>(),
        ),
        // Provides ServiceViewModel and immediately fetches all services at startup.
        BlocProvider<ServiceViewModel>(
          create: (context) => serviceLocator<ServiceViewModel>()..add(GetAllServicesEvent()),
        ),
        // Provides BookingViewModel to the entire app.
        BlocProvider<BookingViewModel>(
          create: (context) => serviceLocator<BookingViewModel>(),
        ),
        // ✅ FIX: Provide the ReviewBloc that was missing.
        // This makes ReviewBloc available globally, fixing the "ProviderNotFoundError".
        // It uses the serviceLocator to create the instance you already configured.
        BlocProvider<ReviewBloc>(
          create: (context) => serviceLocator<ReviewBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MotoFix',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white70,
              fontFamily: 'OpenSans', // Set global font
            ),
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'OpenSans', // Set global font
            ),
            bodySmall: TextStyle(
              color: Colors.white60,
              fontFamily: 'OpenSans', // Set global font
            ),
          ),
        ),
        // The SplashPage and all subsequent screens will now have access
        // to all the BLoCs provided above, including ReviewBloc.
        home: const SplashPage(),
      ),
    );
  }
}
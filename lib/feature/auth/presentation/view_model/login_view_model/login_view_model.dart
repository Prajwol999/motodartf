import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/core/common/snack_bar.dart';
import 'package:motofix_app/feature/auth/domain/use_case/login_use_case.dart';
import 'package:motofix_app/feature/auth/presentation/view/signup_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:motofix_app/view/dashboard_screen.dart';

import '../../../../../app/cubit/bottom_navigation_cubit.dart';
import '../../../../../app/service_locator/service_locator.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterView>(_onNavigateToRegisterView);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<NavigateToHomeView>(_onNavigateToHomeView);
  }

  void _onNavigateToRegisterView(
      NavigateToRegisterView event,
      Emitter<LoginState> emit,
      ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: serviceLocator<RegisterViewModel>(),
            child: const SignUpPage(),
          ),
        ),
      );
    }
  }

  // void _onNavigateToHomeView(
  //     NavigateToHomeView event,
  //     Emitter<LoginState> emit,
  //     ) {
  //   if (event.context.mounted) {
  //     Navigator.pushAndRemoveUntil(
  //       event.context,
  //       MaterialPageRoute(
  //         builder: (_) => const MotoFixDashboard(),
  //       ),
  //           (route) => false,
  //     );
  //   }
  // }

  void _onNavigateToHomeView(
      NavigateToHomeView event,
      Emitter<LoginState> emit,
      ) async {
    // This navigation logic is perfect for your goal.
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(
        // It provides the BottomNavigationCubit to the DashboardView
        builder: (_) => BlocProvider(
          create: (_) => BottomNavigationCubit(),
          child: const MotoFixDashboard(), // Navigates to the main dashboard
        ),
      ),
          (route) => false, // Clears the navigation stack
    );
  }

  void _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: 'Invalid credentials. Please try again.',
            color: Colors.red,
          );
        }
      }, (email) {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: 'Login successful!',
            color: Colors.green,
          );

          // Delay to allow the snackbar to be visible before navigation
          Future.delayed(const Duration(milliseconds: 600), () {
            add(NavigateToHomeView(context: event.context));
          });
        }
      },
    );
  }
}

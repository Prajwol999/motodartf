import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/auth/domain/use_case/checkout_user_status_usecase.dart';
import 'package:motofix_app/feature/splash/view_model/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  SplashCubit({required CheckAuthStatusUseCase checkAuthStatusUseCase})
      : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        super(SplashInitial());

  Future<void> checkAuthentication() async {
    final result = await _checkAuthStatusUseCase.call();

    result.fold(
      (failure) {
        emit(SplashUnauthenticated());
      },
      (token) {
        if (token != null) {
          emit(SplashAuthenticated());
        } else {
          emit(SplashUnauthenticated());
        }
      },
    );
  }
}

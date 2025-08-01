import 'package:dartz/dartz.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';

class UserLogoutUseCase implements UseCaseWithoutParams<void> {
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUseCase({required TokenSharedPrefs tokenSharedPrefs})
      : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    return await _tokenSharedPrefs.clearToken();
  }
}

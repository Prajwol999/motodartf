import 'package:dartz/dartz.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';

class CheckAuthStatusUseCase implements UseCaseWithoutParams<String?> {
  final TokenSharedPrefs _tokenSharedPrefs;

  CheckAuthStatusUseCase({required TokenSharedPrefs tokenSharedPrefs})
      : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, String?>> call() async {
    return await _tokenSharedPrefs.getToken();
  }
}

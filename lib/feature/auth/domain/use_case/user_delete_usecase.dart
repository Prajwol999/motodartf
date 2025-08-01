import 'package:dartz/dartz.dart';

import '../../../../app/shared_pref/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';


class UserDeleteUsecase implements UseCaseWithoutParams<void> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserDeleteUsecase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _iUserRepository = iUserRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
          (failure) => Left(failure),
          (token) async => await _iUserRepository.deleteUser(token),
    );
  }
}
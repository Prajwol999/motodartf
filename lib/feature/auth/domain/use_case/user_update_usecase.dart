import 'package:dartz/dartz.dart';

import '../../../../app/shared_pref/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/auth_entity.dart';
import '../repository/user_repository.dart';

class UserUpdateUsecase implements UseCaseWithParams<UserEntity, UserEntity> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserUpdateUsecase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
        _iUserRepository = iUserRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
          (failure) => Left(failure),
          (token) async => await _iUserRepository.updateUser(params, token),
    );
  }
}
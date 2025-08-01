import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';
import 'package:motofix_app/feature/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String password;
  final String email;

  const RegisterUserParams({
    required this.fullName,
    required this.password,
    required this.email,
  });

  const RegisterUserParams.initial({
    required this.fullName,
    required this.password,
    required this.email,
  });

  @override
  List<Object?> get props => [fullName, password, email];
}

class UserRegisterUseCase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );

    return _userRepository.registerUser(userEntity);
  }
}

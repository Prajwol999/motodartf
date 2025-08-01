import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);


  // user profile ==========
  Future<Either<Failure, UserEntity>> getUser(String? token);
  Future<Either<Failure, UserEntity>> updateUser(
      UserEntity user,
      String? token,
      );
  Future<Either<Failure, void>> deleteUser(String? token);
}
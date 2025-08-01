import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';
import 'package:motofix_app/feature/auth/domain/repository/user_repository.dart';


class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userLocalDataSource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "failed to register : $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String? token) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(String? token) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user, String? token) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
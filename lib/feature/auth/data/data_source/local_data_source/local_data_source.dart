

import 'dart:io';

import 'package:motofix_app/core/network/hive_service.dart';
import 'package:motofix_app/feature/auth/data/data_source/user_data_source.dart';
import 'package:motofix_app/feature/auth/data/model/user_hive_model.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(entity);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration Failed : $e");
    }
  }

  @override
  Future<void> deleteUser(String? token) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUser(String? token) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user, String? token) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> updateUserWithPicture(UserEntity user, File profilePictureFile) {
    // TODO: implement updateUserWithPicture
    throw UnimplementedError();
  }
}
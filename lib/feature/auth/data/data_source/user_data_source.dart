import 'dart:io';

import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

abstract class IUserDataSource {
  Future<void> registerUser(UserEntity user);

  Future<String> loginUser(String email, String password);

  Future<UserEntity> getUser(String? token);

  Future<UserEntity> updateUser(UserEntity user, String? token);

  Future<void> deleteUser(String? token);

  Future<UserEntity> updateUserWithPicture(UserEntity user, File profilePictureFile) ;
}
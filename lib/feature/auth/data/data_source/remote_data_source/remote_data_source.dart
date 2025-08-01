import 'dart:io';

import 'package:dio/dio.dart';
import 'package:motofix_app/feature/auth/data/model/user_api_model.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

import '../../../../../app/constant/api_endpoints.dart';
import '../../../../../core/network/api_service.dart';
import '../user_data_source.dart';


class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(
          "Failed to login user : ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to Login user : ${e.message}");
    } catch (e) {
      throw Exception("failed to login user $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        // 3. Send the user data as JSON in the request body.
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
            "Failed to register user : ${response.statusMessage}");
      }
    }
    on DioException catch (e) {
      throw Exception("Failed to register user : ${e.message}");
    } catch (e) {
      throw Exception('Failed to register student : $e');
    }

   
  }

  @override
  Future<void> deleteUser(String? token) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUser(String? token) async {
    try {
      // An endpoint to get a specific user should include the token
      final response = await _apiService.dio.get(
        ApiEndpoints.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('GET USER RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        // Assuming the API returns the user object directly or nested under a 'data' key
        final userJson = response.data['data'] ?? response.data;
        final userApiModel = UserApiModel.fromJson(userJson);
        return userApiModel.toEntity();
      } else {
        throw Exception('Failed to fetch user');
      }
    } on DioException catch (e) {
      throw Exception(
        "Failed to fetch user: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user, String? token) async{
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final data =
      userApiModel.toJson()..removeWhere((key, value) => value == null);

      final response = await _apiService.dio.put(
        ApiEndpoints.userProfile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final updatedUserJson = response.data['data'] ?? response.data;
        final updatedUserApiModel = UserApiModel.fromJson(updatedUserJson);
        return updatedUserApiModel.toEntity();
      } else {
        throw Exception("Failed to update user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception(
        "Failed to update user: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<UserEntity> updateUserWithPicture(UserEntity user, File profilePictureFile) {
    // TODO: implement updateUserWithPicture
    throw UnimplementedError();
  }
}
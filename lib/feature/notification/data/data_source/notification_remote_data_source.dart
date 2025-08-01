
import 'package:dio/dio.dart';
import 'package:motofix_app/core/network/api_service.dart'; // Assuming you have an ApiService that configures Dio
import 'package:motofix_app/feature/notification/data/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSource({required this.dio});

  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Use the key you use to store the auth token

    if (token == null) {
      throw Exception('Auth token not found!');
    }

    try {
      final response = await dio.get(
        '/user/notifications', // This is the endpoint we created on the backend
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception('Failed to load notifications: ${e.message}');
    } catch (e) {
      // Handle other errors
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> markAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found!');
    }

    try {
      await dio.put(
        '/user/notifications/mark-read', // The "mark as read" endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Failed to mark notifications as read: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
import 'package:dio/dio.dart';
import 'package:motofix_app/app/constant/api_endpoints.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/core/network/dio_error_interceptor.dart';

import '../../../domain/entity/booking_entity.dart';
import '../../dto/get_all_booking_dto.dart';
import '../../model/booking_api_model.dart';
import '../booking_data_source.dart';

class RemoteBookingDataSource implements BookingDataSource {
  final ApiService _apiService;
  RemoteBookingDataSource({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<void> createBooking(BookingEntity entity, String? token) async {
    try {
      final String? serviceId = entity.serviceType;
      if (serviceId == null || serviceId.isEmpty) {
        throw Exception(
            'Programming error: serviceId must be provided in the serviceType field of the BookingEntity.');
      }

      final Map<String, dynamic> requestBody = {
        'serviceId': serviceId,
        'bikeModel': entity.bikeModel,
        'date': entity.date?.toIso8601String(),
        'notes': entity.notes,
      };

      final response = await _apiService.dio.post(
        ApiEndpoints.createBooking,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: requestBody,
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(
            'Failed to create booking: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'Failed to create booking: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteUserBooking(String bookingId, String? token) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.deleteBooking}/$bookingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        // Handle unexpected status codes
        throw Exception('Failed to delete booking : ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Handle DioException
      throw Exception('Failed to delete bookings: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete Bookings : $e');
    }
  }

  @override
  Future<List<BookingEntity>> getUserBooking(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllBooking,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("All booking user $response");

      if (response.statusCode == 200) {
        GetAllBookingDto getAllBookingDto =
            GetAllBookingDto.fromJson(response.data);
        return BookingApiModel.toEntityList(getAllBookingDto.data);
      } else {
        throw Exception('Failed to fetch bookings  :${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception("failed to booking : ${e.message} ");
    } catch (e) {
      throw Exception('An unexpected error occured : $e');
    }
  }
}

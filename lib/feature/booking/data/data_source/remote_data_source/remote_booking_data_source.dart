import 'package:dio/dio.dart';
import 'package:motofix_app/app/constant/api_endpoints.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/feature/booking/data/data_source/booking_data_source.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';
import 'package:motofix_app/feature/booking/data/dto/get_all_booking_dto.dart';
import 'package:motofix_app/feature/booking/data/model/booking_api_model.dart';

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

      // Assuming your ApiService is configured with the baseUrl.
      final response = await _apiService.dio.post(
        ApiEndpoints.createBooking,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: requestBody,
      );

      // A successful creation should return 201.
      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create booking. Status: ${response.statusCode}, Message: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'API Error on create booking: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during booking creation: $e');
    }
  }

  @override
  Future<void> deleteUserBooking(String bookingId, String? token) async {
    try {
      // CRITICAL FIX: Replace the ':id' placeholder with the actual bookingId.
      final String deleteUrl = 
          ApiEndpoints.deleteBooking.replaceAll(':id', bookingId);

      final response = await _apiService.dio.delete(
        deleteUrl, // Use the corrected URL
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // A successful deletion can be 200 (OK) or 204 (No Content).
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete booking. Status: ${response.statusCode}, Message: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'API Error on delete booking: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during booking deletion: $e');
    }
  }

  @override
  Future<List<BookingEntity>> getUserBooking(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllBooking,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        GetAllBookingDto getAllBookingDto =
            GetAllBookingDto.fromJson(response.data);
        return BookingApiModel.toEntityList(getAllBookingDto.data);
      } else {
        throw Exception(
            'Failed to fetch bookings. Status: ${response.statusCode}, Message: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'API Error fetching bookings: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching bookings: $e');
    }
  }

  @override
  Future<List<BookingEntity>> getCompletedBookings(String? token) async {
    try {
      // NOTE: Ensure your ApiService is configured with the baseUrl.
      // The path in ApiEndpoints should be relative (e.g., 'user/booking/completed').
      final response = await _apiService.dio.get(
        ApiEndpoints.completedBookings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        GetAllBookingDto getAllBookingDto = GetAllBookingDto.fromJson(response.data);
        return BookingApiModel.toEntityList(getAllBookingDto.data);
      } else {
        throw Exception(
            'Failed to fetch completed bookings. Status: ${response.statusCode}, Message: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'API Error fetching completed bookings: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching completed bookings: $e');
    }
  }

  @override
  Future<BookingEntity> getBookingById(String bookingId, String? token) async {
    try {
      // ROBUSTNESS FIX: Replace the placeholder to prevent potential bugs.
      final String bookingUrl = 
          ApiEndpoints.bookingById.replaceAll(':id', bookingId);
          
      final response = await _apiService.dio.get(
        bookingUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // The response data for a single booking is likely nested under a 'data' key.
        BookingApiModel bookingModel = BookingApiModel.fromJson(response.data['data']);
        return bookingModel.toEntity();
      } else {
        throw Exception(
            'Failed to fetch booking details. Status: ${response.statusCode}, Message: ${response.data['message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'API Error fetching booking details: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching booking details: $e');
    }
  }
}
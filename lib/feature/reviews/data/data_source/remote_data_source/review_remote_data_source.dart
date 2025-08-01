import 'package:dio/dio.dart';
import 'package:motofix_app/app/constant/api_endpoints.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/feature/reviews/data/model/review_api_model.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';


class ReviewRemoteDataSource {
  final ApiService _dioService;

  ReviewRemoteDataSource(this._dioService);

  Future<void> createReview(ReviewEntity review, String? token) async {
    try {
      await _dioService.dio.post(
        ApiEndpoints.createReview,
        data: {
          'rating': review.rating,
          'comment': review.comment,
          'bookingId': review.bookingId,
          'serviceId': review.serviceId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['msg'] ?? 'Server Error',
      );
    }
  }

  Future<List<ReviewApiModel>> getServiceReviews(String serviceId, String? token) async {
    try {
      final response = await _dioService.dio.get(
        ApiEndpoints.getServiceReviews.replaceFirst(':serviceId', serviceId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final data = (response.data['data'] as List)
          .map((json) => ReviewApiModel.fromJson(json))
          .toList();
      return data;
    } on DioException catch (e) {
      throw ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['msg'] ?? 'Server Error',
      );
    }
  }
}
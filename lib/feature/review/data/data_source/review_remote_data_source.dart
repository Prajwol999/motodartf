import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:motofix_app/app/constant/api_endpoints.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/feature/review/data/data_source/review_data_source.dart';

import '../model/review_api_model.dart';
import '../../domain/entity/review_entity.dart';
import 'review_remote_data_source.dart';

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs userSharedPrefs;

  ReviewRemoteDataSourceImpl({
    required ApiService apiService,
    required this.userSharedPrefs,
  }) : _apiService = apiService;

  @override
  Future<Either<Failure, bool>> addReview(ReviewEntity review) async {
    try {
      final user = await userSharedPrefs.getToken();
      final token = user.fold((l) => null, (r) => r);

      if (token == null) {
        return Left(ApiFailure(message: "User not authenticated" , statusCode: 401));
      }

      ReviewApiModel apiModel = ReviewApiModel.fromEntity(review);

      final response = await _apiService.dio.post(
        ApiEndpoints.createReview,
        data: apiModel.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          ApiFailure(
            message: response.data['message'] ?? 'Failed to submit review.' , statusCode: 404
          ),
        );
      }
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.response?.data['message'] ?? e.message , statusCode: 403));
    } catch (e) {
      return Left(ApiFailure(message: e.toString() , statusCode: 500));
    }
  }

    @override
  Future<Either<Failure, List<ReviewEntity>>> getServiceReviews(String serviceId) async {
    try {
      final user = await userSharedPrefs.getToken();
      final token = user.fold((l) => null, (r) => r);

      if (token == null) {
        return Left(ApiFailure(message: "User not authenticated" , statusCode: 401));
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.getReviews.replaceFirst(':serviceId', serviceId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> reviewData = response.data['data'];
        final reviews = reviewData.map((review) => ReviewApiModel.fromJson(review).toEntity()).toList();
        return Right(reviews);
      } else {
        return Left(
          ApiFailure(
            message: response.data['message'] ?? 'Failed to fetch reviews.',
            statusCode: response.statusCode!,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.response?.data['message'] ?? e.message, statusCode: 500));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500) ,);
    }
  }
  }

import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/reviews/data/data_source/remote_data_source/review_remote_data_source.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/reviews/domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> createReview(ReviewEntity review, String? token) async {
    try {
      await _remoteDataSource.createReview(review, token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getServiceReviews(
      String serviceId, String? token) async {
    try {
      final reviewModels = await _remoteDataSource.getServiceReviews(serviceId, token);
      final reviewEntities = reviewModels.map((model) => model.toEntity()).toList();
      return Right(reviewEntities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }
}
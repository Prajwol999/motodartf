import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';

abstract class IReviewRepository {
  Future<Either<Failure, void>> createReview(ReviewEntity review, String? token);
  Future<Either<Failure, List<ReviewEntity>>> getServiceReviews(
      String serviceId, String? token);
}
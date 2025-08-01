import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import '../entity/review_entity.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, bool>> addReview(ReviewEntity review);
   Future<Either<Failure, List<ReviewEntity>>> getServiceReviews(String serviceId);
}
import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/reviews/domain/repository/review_repository.dart';

class GetServiceReviewsUseCase {
  final IReviewRepository _repository;

  GetServiceReviewsUseCase(this._repository);

  Future<Either<Failure, List<ReviewEntity>>> call(
      String serviceId, String? token) {
    return _repository.getServiceReviews(serviceId, token);
  }
}
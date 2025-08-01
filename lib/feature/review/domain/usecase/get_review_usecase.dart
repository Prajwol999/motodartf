import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/domain/repository/review_repository.dart';

class GetServiceReviewsUsecase {
  final IReviewRepository repository;

  GetServiceReviewsUsecase({required this.repository});

  Future<Either<Failure, List<ReviewEntity>>> call(String serviceId) {
    return repository.getServiceReviews(serviceId);
  }
}
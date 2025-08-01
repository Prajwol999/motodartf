import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/reviews/domain/repository/review_repository.dart';

class CreateReviewUseCase {
  final IReviewRepository _repository;

  CreateReviewUseCase(this._repository);

  Future<Either<Failure, void>> call(ReviewEntity review, String? token) {
    return _repository.createReview(review, token);
  }
}
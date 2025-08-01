import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import '../entity/review_entity.dart';
import '../repository/review_repository.dart';

class AddReviewUsecase {
  final IReviewRepository repository;

  AddReviewUsecase({required this.repository});

  Future<Either<Failure, bool>> call(ReviewEntity review) {
    return repository.addReview(review);
  }
}
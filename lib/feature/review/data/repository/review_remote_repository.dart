import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/review/data/data_source/review_data_source.dart';
import '../data_source/review_remote_data_source.dart';
import '../../domain/entity/review_entity.dart';
import '../../domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> addReview(ReviewEntity review) {
    return remoteDataSource.addReview(review);
  }
  
  @override
  Future<Either<Failure, List<ReviewEntity>>> getServiceReviews(String serviceId) {
    // TODO: implement getServiceReviews
    return remoteDataSource.getServiceReviews(serviceId) ;
  }
}
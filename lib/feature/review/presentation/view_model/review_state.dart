import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {}

class ReviewFailure extends ReviewState {
  final String error;

  const ReviewFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ServiceReviewsLoading extends ReviewState {}

class ServiceReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  const ServiceReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ServiceReviewsError extends ReviewState {
  final String message;

  const ServiceReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
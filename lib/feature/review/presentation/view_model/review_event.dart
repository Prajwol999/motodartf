import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class AddReviewSubmitted extends ReviewEvent {
  final ReviewEntity review;

  const AddReviewSubmitted(this.review);

  @override
  List<Object> get props => [review];
}

class FetchServiceReviews extends ReviewEvent {
  final String serviceId;

  const FetchServiceReviews(this.serviceId);

  @override
  List<Object> get props => [serviceId];
}

class ReviewReset extends ReviewEvent {}
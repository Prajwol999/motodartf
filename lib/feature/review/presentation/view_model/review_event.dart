
// Abstract base class for all events related to the review feature
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

/// Event triggered to reset the BLoC's state back to initial.
/// This is useful after a success or failure dialog is dismissed.
class ReviewReset extends ReviewEvent {}
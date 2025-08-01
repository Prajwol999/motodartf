part of 'review_view_model.dart';

class ReviewState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ReviewEntity> reviews;
  final bool reviewSubmitted;

  const ReviewState({
    required this.isLoading,
    this.error,
    required this.reviews,
    required this.reviewSubmitted,
  });

  const ReviewState.initial()
      : isLoading = false,
        error = null,
        reviews = const [],
        reviewSubmitted = false;

  ReviewState copyWith({
    bool? isLoading,
    String? error,
    List<ReviewEntity>? reviews,
    bool? reviewSubmitted,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Don't carry over old errors
      reviews: reviews ?? this.reviews,
      reviewSubmitted: reviewSubmitted ?? this.reviewSubmitted,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, reviews, reviewSubmitted];
}
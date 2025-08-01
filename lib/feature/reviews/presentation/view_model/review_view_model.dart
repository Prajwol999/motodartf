import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/feature/reviews/domain/usecases/get_service_reviews_usecase.dart';

import '../../domain/entity/review_entity.dart';
import '../../domain/usecases/create_review_usecase.dart';

part 'review_state.dart';

class ReviewViewModel extends Cubit<ReviewState> {
  final CreateReviewUseCase createReviewUseCase;
  final GetServiceReviewsUseCase getServiceReviewsUseCase;
  final TokenSharedPrefs tokenSharedPrefs;

  ReviewViewModel({
    required this.createReviewUseCase,
    required this.getServiceReviewsUseCase,
    required this.tokenSharedPrefs,
  }) : super(const ReviewState.initial());

  Future<void> createReview(ReviewEntity review) async {
    emit(state.copyWith(isLoading: true));
    final token = await tokenSharedPrefs.getToken();
    final result = await createReviewUseCase(review, token as String?);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, reviewSubmitted: true)),
    );
  }

  Future<void> getServiceReviews(String serviceId) async {
    emit(state.copyWith(isLoading: true));
    final token = await tokenSharedPrefs.getToken();
    final result = await getServiceReviewsUseCase(serviceId, token as String?);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (reviews) => emit(state.copyWith(isLoading: false, reviews: reviews)),
    );
  }

  // Helper to reset the submission status
  void resetSubmissionStatus() {
    emit(state.copyWith(reviewSubmitted: false));
  }
}
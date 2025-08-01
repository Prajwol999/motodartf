import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/review/domain/usecase/add_review_usecase.dart';
import 'package:motofix_app/feature/review/domain/usecase/get_review_usecase.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUsecase _addReviewUsecase;
  final GetServiceReviewsUsecase _getServiceReviewsUsecase;

  ReviewBloc({
    required AddReviewUsecase addReviewUsecase,
    required GetServiceReviewsUsecase getServiceReviewsUsecase,
  })  : _addReviewUsecase = addReviewUsecase,
        _getServiceReviewsUsecase = getServiceReviewsUsecase,
        super(ReviewInitial()) {
    on<AddReviewSubmitted>(_onAddReviewSubmitted);
    on<FetchServiceReviews>(_onFetchServiceReviews);
    on<ReviewReset>(_onReviewReset);
  }

  Future<void> _onAddReviewSubmitted(
    AddReviewSubmitted event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    final result = await _addReviewUsecase(event.review);
    result.fold(
      (failure) => emit(ReviewFailure(failure.message)),
      (success) => emit(ReviewSuccess()),
    );
  }

  Future<void> _onFetchServiceReviews(
    FetchServiceReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ServiceReviewsLoading());
    final result = await _getServiceReviewsUsecase(event.serviceId);
    result.fold(
      (failure) => emit(ServiceReviewsError(failure.message)),
      (reviews) => emit(ServiceReviewsLoaded(reviews)),
    );
  }

  void _onReviewReset(
    ReviewReset event,
    Emitter<ReviewState> emit,
  ) {
    emit(ReviewInitial());
  }
}
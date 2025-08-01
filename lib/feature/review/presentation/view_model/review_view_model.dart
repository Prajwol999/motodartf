import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/review/domain/usecase/add_review_usecase.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import '../../domain/entity/review_entity.dart';



class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUsecase _addReviewUsecase;

  ReviewBloc({required AddReviewUsecase addReviewUsecase})
      : _addReviewUsecase = addReviewUsecase,
        super(ReviewInitial()) {
    // Register the event handler for when a review is submitted
    on<AddReviewSubmitted>(_onAddReviewSubmitted);
    
    // Register the event handler for resetting the state
    on<ReviewReset>(_onReviewReset);
  }

  Future<void> _onAddReviewSubmitted(
    AddReviewSubmitted event,
    Emitter<ReviewState> emit,
  ) async {
    // Emit Loading state to show a progress indicator in the UI
    emit(ReviewLoading());

    final result = await _addReviewUsecase(event.review);

    // Use .fold to handle either the Failure or the Success case
    result.fold(
      (failure) {
        // On failure, emit the Failure state with the error message
        emit(ReviewFailure(failure.message));
      },
      (success) {
        // On success, emit the Success state
        emit(ReviewSuccess());
      },
    );
  }
  
  void _onReviewReset(
    ReviewReset event,
    Emitter<ReviewState> emit,
  ) {
    // Reset the state back to its initial condition
    emit(ReviewInitial());
  }
}
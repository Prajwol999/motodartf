

// Abstract base class for all states related to the review feature
import 'package:equatable/equatable.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the feature, before any interaction.
class ReviewInitial extends ReviewState {}

/// The state when the review is being submitted to the server.
/// The UI should show a loading indicator in this state.
class ReviewLoading extends ReviewState {}

/// The state when the review has been successfully submitted.
/// The UI can show a success message or navigate away.
class ReviewSuccess extends ReviewState {}

/// The state when an error has occurred during the submission.
/// It carries the error message to be displayed to the user.
class ReviewFailure extends ReviewState {
  final String error;

  const ReviewFailure(this.error);

  @override
  List<Object?> get props => [error];
}
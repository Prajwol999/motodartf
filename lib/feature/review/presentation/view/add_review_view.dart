import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';

/// This is the Screen (View) for adding a new review.
/// Its main responsibilities are to build the UI, send user actions (events)
/// to the BLoC, and listen for state changes from the BLoC to update the UI.
class AddReviewView extends StatefulWidget {
  final String bookingId;

  const AddReviewView({super.key, required this.bookingId});

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 3.0; // Set a default rating

  @override
  void dispose() {
    // Always dispose of controllers to free up resources.
    _commentController.dispose();
    super.dispose();
  }

  /// This method handles the logic for submitting the review.
  void _submitReview() {
    // Hide the keyboard to prevent it from being open during navigation.
    FocusScope.of(context).unfocus();

    // Simple validation for the comment.
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a comment to submit your review.'),
          backgroundColor: Colors.orange,
        ),
      );
      return; // Stop the function if validation fails.
    }

    // Create the review entity with data from the UI.
    final review = ReviewEntity(
      rating: _currentRating,
      comment: _commentController.text.trim(),
      bookingId: widget.bookingId,
    );

    // Add the event to the BLoC to trigger the business logic.
    // context.read() is a shorthand way to get the BLoC instance.
    context.read<ReviewBloc>().add(AddReviewSubmitted(review));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        centerTitle: true,
      ),
      // BlocListener is used for side-effects that happen once per state change,
      // like showing a SnackBar, Dialog, or navigating. It does not rebuild the UI.
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          // --- THIS IS WHERE YOU HANDLE SHOWING THE SNACKBAR ---

          // If the state is a failure, show a red error SnackBar.
          if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }

          // If the state is a success, show a green success SnackBar.
          if (state is ReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Review submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // After showing the SnackBar, pop the screen to go back.
            // Passing 'true' can signal to the previous screen that the operation was successful.
            Navigator.of(context).pop(true);
          }
        },
        // BlocBuilder rebuilds the UI in response to state changes.
        // It's best to wrap only the widgets that need to change.
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            // Determine if the BLoC is in the middle of processing the review.
            final isLoading = state is ReviewLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Your Rating',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  // A slider for rating selection.
                  Slider(
                    value: _currentRating,
                    min: 1,
                    max: 5,
                    divisions: 4, // Creates steps (1, 2, 3, 4, 5)
                    label: _currentRating.toStringAsFixed(0),
                    onChanged: isLoading
                        ? null // Disable slider while loading
                        : (newRating) {
                            setState(() {
                              _currentRating = newRating;
                            });
                          },
                  ),
                  const SizedBox(height: 24),
                  // A text field for the review comment.
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Write your comment here',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    readOnly: isLoading, // Disable text field while loading
                  ),
                  const SizedBox(height: 30),
                  // The submit button.
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // Disable the button visually if loading.
                      backgroundColor: isLoading ? Colors.grey : null,
                    ),
                    // Set onPressed to null to disable the button.
                    onPressed: isLoading ? null : _submitReview,
                    child: isLoading
                        // Show a progress indicator when loading.
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        // Show the text when not loading.
                        : const Text('Submit Review', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
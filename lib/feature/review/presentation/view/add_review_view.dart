import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';

class AddReviewView extends StatefulWidget {
  final String bookingId;

  const AddReviewView({super.key, required this.bookingId});

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 3.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      // BlocListener handles side-effects like showing dialogs/snackbars or navigation
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
          if (state is ReviewSuccess) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Review Submitted'),
                content: const Text('Thank you for your feedback!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(); // Close dialog
                      Navigator.of(context).pop(true); // Pop review page
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        // BlocBuilder handles rebuilding the UI based on the state
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            // Disable the button and show an indicator if the state is loading
            final isLoading = state is ReviewLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (Your RatingBar and TextField widgets remain the same)
                  
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: isLoading ? null : _submitReview,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Review'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitReview() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment.')),
      );
      return;
    }

    final review = ReviewEntity(
      rating: _currentRating,
      comment: _commentController.text.trim(),
      bookingId: widget.bookingId,
    );

    context.read<ReviewBloc>().add(AddReviewSubmitted(review));
  }
}
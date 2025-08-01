import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';

// Import the service locator to get the ReviewBloc

// Import the BLoCs and Entities needed for this screen
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart'; // Using a popular package for ratings


/// This screen displays the detailed information for a single booking.
/// It receives the [BookingHistoryBloc] from its parent and creates its own
/// instance of [ReviewBloc] to handle the review submission logic.
class CompleteDetailScreen extends StatelessWidget {
  final String bookingId;

  const CompleteDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider allows us to provide multiple BLoCs to the widget tree.
    // We are NOT providing BookingHistoryBloc here because it's already provided
    // by the parent route using BlocProvider.value.
    return MultiBlocProvider(
      providers: [
        // We create a new instance of ReviewBloc for this screen.
        // We get it directly from our serviceLocator.
        BlocProvider<ReviewBloc>(
          create: (context) => serviceLocator<ReviewBloc>(),
        ),
      ],
      child: _BookingDetailView(bookingId: bookingId),
    );
  }
}

// Private widget to separate the main UI build from the provider setup.
class _BookingDetailView extends StatefulWidget {
  final String bookingId;
  const _BookingDetailView({required this.bookingId});

  @override
  State<_BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<_BookingDetailView> {
  @override
  void initState() {
    super.initState();
    // Dispatch the initial event to fetch the booking details.
    context.read<BookingHistoryBloc>().add(FetchBookingDetailsById(widget.bookingId));
  }

  // --- DIALOG TO SUBMIT A REVIEW ---
  void _showReviewDialog(BuildContext context, String bookingId) {
    final formKey = GlobalKey<FormState>();
    final commentController = TextEditingController();
    double rating = 3.0; // Default rating

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How would you rate our service?'),
                  const SizedBox(height: 16),
                  // Using flutter_rating_bar for a better UX
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (newRating) {
                      rating = newRating;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: 'Comment', border: OutlineInputBorder()),
                    maxLines: 4,
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter a comment' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final review = ReviewEntity(
                    rating: rating,
                    comment: commentController.text,
                    bookingId: bookingId,
                  );
                  // Use the BuildContext from the main screen to find the BLoC.
                  // It's safer than using dialogContext.
                  context.read<ReviewBloc>().add(AddReviewSubmitted(review));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
      ),
      // BlocListener listens for state changes for side-effects like showing SnackBars.
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review submitted successfully!'), backgroundColor: Colors.green),
            );
            // Crucially, refresh the booking details to update the UI (e.g., hide the review button).
            context.read<BookingHistoryBloc>().add(FetchBookingDetailsById(widget.bookingId));
          } else if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
          builder: (context, state) {
            if (state is BookingHistoryDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingHistoryFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state is BookingHistoryDetailLoaded) {
              // This check is important to prevent building with stale data.
              if (state.booking.id != widget.bookingId) {
                return const Center(child: CircularProgressIndicator());
              }

              final booking = state.booking;
              final formattedDate = DateFormat.yMMMMEEEEd().format(booking.date!);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.serviceType ?? 'Service', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.calendar_today, 'Date', formattedDate),
                    _buildDetailRow(Icons.two_wheeler, 'Bike Model', booking.bikeModel ?? 'N/A'),
                    const Spacer(),

                    // --- Final UI element for review ---
                    if (booking.isReviewed == true)
                      const Center(
                        child: Chip(
                          avatar: Icon(Icons.check_circle_outline, color: Colors.green),
                          label: Text('Review Submitted'),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.rate_review_outlined),
                          label: const Text('Write a Review'),
                          onPressed: () => _showReviewDialog(context, booking.id!),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // Helper widget to keep the UI clean.
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text('$title: $value', style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
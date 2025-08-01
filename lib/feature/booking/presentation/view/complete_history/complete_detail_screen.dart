import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Your service locator
import 'package:motofix_app/app/service_locator/service_locator.dart';

// Your BLoCs, States, Events, and Entities
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';

class CompleteDetailScreen extends StatefulWidget {
  final String bookingId;
  const CompleteDetailScreen({super.key, required this.bookingId});

  @override
  // FIX: State class name now correctly matches the StatefulWidget.
  State<CompleteDetailScreen> createState() => _CompleteDetailScreenState();
}

class _CompleteDetailScreenState extends State<CompleteDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<BookingHistoryBloc>()
        .add(FetchBookingDetailsById(widget.bookingId));
  }

  // FIX: This function now correctly requires `serviceId`.
  void _showReviewDialog(BuildContext context, String bookingId, String serviceId) {
    final formKey = GlobalKey<FormState>();
    final commentController = TextEditingController();
    double rating = 3.0; // Default rating

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Write a Review'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('How would you rate our service?'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              rating > index ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                rating = (index + 1).toDouble();
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Your Comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a comment';
                          }
                          return null;
                        },
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
                      // FIX: ReviewEntity now includes the required serviceId.
                      final review = ReviewEntity(
                        rating: rating,
                        comment: commentController.text,
                        bookingId: bookingId,
                        serviceId: serviceId,
                      );
                      // Use the main screen's context to safely find the BLoC.
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // *** THE FIX: WRAP THE SCAFFOLD WITH A BLOCPROVIDER ***
    // This creates an instance of ReviewBloc and makes it available to all
    // descendant widgets, including the BlocListener below.
    return BlocProvider<ReviewBloc>(
      create: (context) => serviceLocator<ReviewBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Booking Details"),
          actions: [
            BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
              builder: (context, state) {
                if (state is BookingHistoryDetailLoaded &&
                    state.booking.id == widget.bookingId &&
                    state.booking.isReviewed != true) {
                  return IconButton(
                    icon: const Icon(Icons.rate_review_outlined),
                    tooltip: 'Write a Review',
                    // FIX: Pass all required IDs to the dialog function.
                    onPressed: () => _showReviewDialog(
                        context, state.booking.id!, state.booking.serviceType!),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        // Now that the parent Scaffold is wrapped in a BlocProvider,
        // this BlocListener can safely find and listen to the ReviewBloc.
        body: BlocListener<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is ReviewSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Review submitted successfully!'),
                    backgroundColor: Colors.green),
              );
              context
                  .read<BookingHistoryBloc>()
                  .add(FetchBookingDetailsById(widget.bookingId));
            } else if (state is ReviewFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.error}'),
                    backgroundColor: Colors.red),
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
                      Text(
                        booking.serviceType ?? 'Service Details',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow(Icons.calendar_today, 'Date', formattedDate),
                      _buildDetailRow(Icons.two_wheeler, 'Bike Model', booking.bikeModel ?? 'N/A'),
                      _buildDetailRow(Icons.payment, 'Payment',
                          '${booking.paymentMethod ?? 'N/A'} (${booking.paymentStatus ?? 'N/A'})'),
                      _buildDetailRow(Icons.money, 'Total Cost',
                          'Rs. ${booking.totalCost ?? 0}'),
                      if (booking.notes != null && booking.notes!.isNotEmpty)
                        _buildDetailRow(Icons.notes, 'Notes', booking.notes!),

                      const Spacer(),

                      if (booking.isReviewed == true)
                        const Center(
                          child: Chip(
                            avatar: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                            label: Text('Review Submitted'),
                            padding: EdgeInsets.all(12),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart'; // Make sure you have the 'intl' package in pubspec.yaml


// // Import the detail screen you will navigate to
// import 'package:motofix_app/feature/booking/presentation/view/complete_history/complete_detail_screen.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';


// class CompletedBookingsListView extends StatelessWidget {
//   const CompletedBookingsListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Booking History"),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
//         builder: (context, state) {

//           // --- LOADING STATE ---
//           // Show a spinner while the list is being fetched.
//           // This covers both the initial load and any subsequent reloads.
//           if (state is BookingHistoryListLoading || state is BookingHistoryInitial) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // --- FAILURE STATE ---
//           // Show a user-friendly error message if the fetch fails.
//           if (state is BookingHistoryFailure) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Failed to load history: ${state.error}',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             );
//           }

//           // --- SUCCESS (LOADED) STATE ---
//           // This is the primary success case where we have the data.
//           if (state is BookingHistoryListLoaded) {
//             // Handle the case where the user has no completed bookings.
//             if (state.bookings.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'You have no completed bookings yet.',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               );
//             }

//             // Build the ListView to display each booking.
//             return ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: state.bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = state.bookings[index];
                
//                 // Safely format the date, providing a fallback.
//                 final formattedDate = booking.date != null
//                     ? DateFormat.yMMMd().format(booking.date!)
//                     : 'No date';

//                 return Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                     title: Text(
//                       // Use a null-aware operator for safety.
//                       booking.serviceType ?? 'Unknown Service',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text('Completed on $formattedDate for ${booking.bikeModel ?? 'N/A'}'),
//                     ),
//                     trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//                     onTap: () {
//                       // Ensure the booking ID exists before navigating.
//                       final bookingId = booking.id;
//                       if (bookingId != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) {
//                               // Use BlocProvider.value to pass the *same instance* of the BLoC
//                               // to the detail screen. This is efficient and correct.
//                               return BlocProvider.value(
//                                 value: BlocProvider.of<BookingHistoryBloc>(context),
//                                 child: CompleteDetailScreen(bookingId: bookingId),
//                               );
//                             },
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//             );
//           }

//           // Fallback case: Should not be reached if states are handled correctly,
//           // but good practice to have a default.
//           return const Center(child: Text('An unknown state occurred.'));
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Make sure you have the 'intl' package in pubspec.yaml

// Import your BLoC event file
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';

// Import the detail screen you will navigate to
import 'package:motofix_app/feature/booking/presentation/view/complete_history/complete_detail_screen.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';


class CompletedBookingsListView extends StatelessWidget {
  const CompletedBookingsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
        builder: (context, state) {

          // --- LOADING STATE ---
          if (state is BookingHistoryListLoading || state is BookingHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- FAILURE STATE ---
          if (state is BookingHistoryFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load history: ${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // --- SUCCESS (LOADED) STATE ---
          // This now correctly handles BOTH ListLoaded and DetailLoaded states.
          if (state is BookingHistoryWithData) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Text(
                  'You have no completed bookings yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Build the ListView to display each booking.
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                
                final formattedDate = booking.date != null
                    ? DateFormat.yMMMd().format(booking.date!)
                    : 'No date';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: Text(
                      booking.serviceType ?? 'Unknown Service',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('Completed on $formattedDate for ${booking.bikeModel ?? 'N/A'}'),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    
                    // --- 💡 THIS IS THE FIX 💡 ---
                    onTap: () {
                      final bookingId = booking.id;
                      if (bookingId != null) {
                        // We use .then() on Navigator.push. The code inside .then()
                        // will execute automatically AFTER the detail screen is
                        // popped (when the user presses the back button).
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<BookingHistoryBloc>(context),
                              child: CompleteDetailScreen(bookingId: bookingId),
                            ),
                          ),
                        ).then((_) {
                          // This is the perfect place to tell the BLoC to
                          // refresh the list, ensuring we are always in a
                          // state that this screen can render.
                          context.read<BookingHistoryBloc>().add(FetchCompletedBookingsList());
                        });
                      }
                    },
                  ),
                );
              },
            );
          }

          // Fallback case
          return const Center(child: Text('An unknown state occurred.'));
        },
      ),
    );
  }
}
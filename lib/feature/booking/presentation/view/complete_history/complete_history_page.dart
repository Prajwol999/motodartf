import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';

// 1. Import your service locator instance.

// 3. Import the child widget that will be displayed.
import 'package:motofix_app/feature/booking/presentation/view/complete_history/complete_list_view.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_view_model.dart';

/// This widget is the entry point for the Booking History feature.
/// Its primary role is to create and provide the [BookingHistoryBloc]
/// to all child widgets, starting with [CompletedBookingsListView].
class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // THE FIX: Instead of using `context.read`, we directly ask the `serviceLocator`
      // to retrieve the `BookingHistoryBloc` instance. `GetIt` already knows how
      // to build this BLoC with all of its required use case dependencies.
      create: (context) => serviceLocator<BookingHistoryBloc>()
        // The cascade operator `..` allows us to call a method on the newly created
        // object and then return the object itself. Here, we immediately dispatch
        // the initial event to start fetching data.
        ..add(FetchCompletedBookingsList()),
        
      // The child widget now has access to the `BookingHistoryBloc` instance
      // created above it in the widget tree.
      child: const CompletedBookingsListView(),
    );
  }
}
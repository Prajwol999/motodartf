

// Base class for all events related to the booking history feature.
import 'package:equatable/equatable.dart';

abstract class BookingHistoryEvent extends Equatable {
  const BookingHistoryEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch the list of all completed bookings.
class FetchCompletedBookingsList extends BookingHistoryEvent {}

/// Event to fetch the details of a single booking by its ID.
class FetchBookingDetailsById extends BookingHistoryEvent {
  final String bookingId;

  const FetchBookingDetailsById(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}
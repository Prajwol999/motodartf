
// Base class for all states within the booking history feature.
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';

abstract class BookingHistoryState extends Equatable {
  const BookingHistoryState();

  @override
  List<Object> get props => [];
}

// --- States for the List View ---

/// The initial state before anything is fetched.
class BookingHistoryInitial extends BookingHistoryState {}

/// State when the list of completed bookings is being fetched.
class BookingHistoryListLoading extends BookingHistoryState {}

/// State when the list of completed bookings has been successfully loaded.
class BookingHistoryListLoaded extends BookingHistoryState {
  final List<BookingEntity> bookings;

  const BookingHistoryListLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

// --- States for the Detail View ---

/// State when a single booking's details are being fetched.
class BookingHistoryDetailLoading extends BookingHistoryState {}

/// State when a single booking's details have been successfully loaded.
class BookingHistoryDetailLoaded extends BookingHistoryState {
  final BookingEntity booking;

  const BookingHistoryDetailLoaded(this.booking);

  @override
  List<Object> get props => [booking];
}


// --- Common Failure State ---

/// A shared failure state for any operation that might fail.
class BookingHistoryFailure extends BookingHistoryState {
  final String error;

  const BookingHistoryFailure(this.error);

  @override
  List<Object> get props => [error];
}
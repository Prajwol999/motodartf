import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

// Represents the initial state before any action has been taken.
class BookingInitial extends BookingState {}

// Represents a state where data is being fetched (e.g., the initial load).
class BookingLoading extends BookingState {}

// Represents a successful state where a list of bookings is available.
// It can ALSO carry optional messages for the UI to display (e.g., in a snackbar).
class BookingLoadSuccess extends BookingState {
  final List<BookingEntity> bookings;
  final String? successMessage; // Optional: For success feedback (e.g., "Booking deleted")
  final String? error;          // Optional: For error feedback (e.g., "Failed to delete")

  const BookingLoadSuccess(
    this.bookings, {
    this.successMessage,
    this.error,
  });

  @override
  List<Object?> get props => [bookings, successMessage, error];
}

// Represents a general failure state, typically when the whole screen fails to load.
class BookingFailure extends BookingState {
  final String message; // Renamed from 'error' for clarity
  const BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// This state can be used for actions that navigate away or don't need to preserve the list,
// such as a successful booking creation that pops the current screen.
class BookingActionSuccess extends BookingState {
  final String message;
  const BookingActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
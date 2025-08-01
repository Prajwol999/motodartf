import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoadSuccess extends BookingState {
  final List<BookingEntity> bookings;
  final String? successMessage; // ADDED: To carry a success message

  // UPDATED: Added optional successMessage parameter
  const BookingLoadSuccess(this.bookings, {this.successMessage});

  @override
  List<Object?> get props => [bookings, successMessage];
}

// This state is for one-off actions like creation or deletion success feedback
class BookingActionSuccess extends BookingState {
  final String message;
  const BookingActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingFailure extends BookingState {
  final String error;
  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

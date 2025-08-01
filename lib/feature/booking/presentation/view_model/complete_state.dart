// lib/feature/booking/presentation/view_model/complete_state.dart

import 'package:equatable/equatable.dart';
// Make sure this import points to your actual BookingEntity file
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';

abstract class BookingHistoryState extends Equatable {
  const BookingHistoryState();

  @override
  List<Object?> get props => [];
}

class BookingHistoryInitial extends BookingHistoryState {}
class BookingHistoryListLoading extends BookingHistoryState {}

class BookingHistoryFailure extends BookingHistoryState {
  final String error;
  const BookingHistoryFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Base state that holds the list of bookings.
abstract class BookingHistoryWithData extends BookingHistoryState {
  final List<BookingEntity> bookings;
  const BookingHistoryWithData(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class BookingHistoryListLoaded extends BookingHistoryWithData {
  const BookingHistoryListLoaded(super.bookings);
}

// *** THE FIX: Define the missing state class ***
// This state represents that details for one item are being loaded,
// while still retaining the main list in the background.
class BookingHistoryDetailLoading extends BookingHistoryWithData {
  const BookingHistoryDetailLoading({required List<BookingEntity> bookings})
      : super(bookings);
}

// This state represents that details have been successfully loaded.
class BookingHistoryDetailLoaded extends BookingHistoryWithData {
  final BookingEntity booking;

  const BookingHistoryDetailLoaded({
    required this.booking,
    required List<BookingEntity> bookings,
  }) : super(bookings);

  @override
  List<Object> get props => [booking, bookings];
}
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserBookingsEvent extends BookingEvent {}


class CreateBookingEvent extends BookingEvent {
  final String serviceId;
  final String bikeModel;
  final DateTime date;
  final String? notes;

  const CreateBookingEvent({
    required this.serviceId,
    required this.bikeModel,
    required this.date,
    this.notes,
  });

  @override
  List<Object?> get props => [serviceId, bikeModel, date, notes];
}

class DeleteBookingEvent extends BookingEvent {
  final String bookingId;
  const DeleteBookingEvent({required this.bookingId});
  @override
  List<Object?> get props => [bookingId];
}
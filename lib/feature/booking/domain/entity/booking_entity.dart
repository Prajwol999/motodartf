import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String customerName;
  final String serviceType;
  final String bikeModel;
  final DateTime date;
  final String notes;
  final double totalCost;
  final String status;
  final String paymentStatus;
  final bool isPaid;
  final String paymentMethod;
  // --- NEW FIELD ---
  final bool isReviewed;

  // --- THIS IS THE CORRECTED CONSTRUCTOR ---
  const BookingEntity({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.bikeModel,
    required this.date,
    required this.notes,
    required this.totalCost,
    required this.status,
    required this.paymentStatus,
    required this.isPaid,
    required this.paymentMethod,
    required this.isReviewed,
  });

  @override
  List<Object?> get props => [
        id,
        customerName,
        serviceType,
        bikeModel,
        date,
        notes,
        totalCost,
        status,
        paymentStatus,
        isPaid,
        paymentMethod,
        isReviewed,
      ];
}
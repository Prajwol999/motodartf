import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String? id;
  final String? customerName;
  final String? serviceType;
  final String? bikeModel;
  final DateTime? date;
  final String? notes;
  final double? totalCost;
  final String? status;
  final String? paymentStatus; // 'Pending', 'Paid'
  final bool? isPaid;
  final String? paymentMethod; // 'COD', 'Khalti'

  const BookingEntity({
    this.id,
    this.customerName,
    this.serviceType,
    this.bikeModel,
    this.date,
    this.notes,
    this.totalCost,
    this.status,
    this.paymentStatus,
    this.isPaid,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [id, status, paymentStatus, date];
}

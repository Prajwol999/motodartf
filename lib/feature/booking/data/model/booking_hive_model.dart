import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/booking_entity.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: 1)
class BookingHiveModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? customerName;
  @HiveField(2)
  final String? serviceType;
  @HiveField(3)
  final String? bikeModel;
  @HiveField(4)
  final DateTime? date;
  @HiveField(5)
  final String? notes;
  @HiveField(6)
  final double? totalCost;
  @HiveField(7)
  final String? status;
  @HiveField(8)
  final String? paymentStatus;
  @HiveField(9)
  final bool? isPaid;
  @HiveField(10)
  final String? paymentMethod;

  BookingHiveModel({
    String? id ,
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
  }) : id = id ?? const Uuid().v4();






  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      customerName: customerName,
      serviceType: serviceType,
      bikeModel: bikeModel,
      date: date,
      notes: notes,
      totalCost: totalCost,
      status: status,
      paymentStatus: paymentStatus,
      isPaid: isPaid,
      paymentMethod: paymentMethod,
    );
  }

  // Corrected and completed fromEntity method
  factory BookingHiveModel.fromEntity(BookingEntity entity) => BookingHiveModel(
    id: entity.id,
    customerName: entity.customerName,
    serviceType: entity.serviceType,
    bikeModel: entity.bikeModel,
    date: entity.date,
    notes: entity.notes,
    totalCost: entity.totalCost,
    status: entity.status,
    paymentStatus: entity.paymentStatus,
    isPaid: entity.isPaid,
    paymentMethod: entity.paymentMethod,
  );

  static List<BookingEntity> toEntityList(List<BookingHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
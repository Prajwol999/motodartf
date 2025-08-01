// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingApiModel _$BookingApiModelFromJson(Map<String, dynamic> json) =>
    BookingApiModel(
      id: json['_id'] as String?,
      customerName: json['customerName'] as String?,
      serviceType: json['serviceType'] as String?,
      bikeModel: json['bikeModel'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      totalCost: (json['totalCost'] as num?)?.toDouble(),
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      isPaid: json['isPaid'] as bool?,
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$BookingApiModelToJson(BookingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'customerName': instance.customerName,
      'serviceType': instance.serviceType,
      'bikeModel': instance.bikeModel,
      'date': instance.date?.toIso8601String(),
      'notes': instance.notes,
      'totalCost': instance.totalCost,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'isPaid': instance.isPaid,
      'paymentMethod': instance.paymentMethod,
    };

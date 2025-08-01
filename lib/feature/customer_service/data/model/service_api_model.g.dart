// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceApiModel _$ServiceApiModelFromJson(Map<String, dynamic> json) =>
    ServiceApiModel(
      serviceId: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$ServiceApiModelToJson(ServiceApiModel instance) =>
    <String, dynamic>{
      '_id': instance.serviceId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
    };

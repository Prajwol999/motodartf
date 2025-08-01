// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_service_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllServiceDto _$GetAllServiceDtoFromJson(Map<String, dynamic> json) =>
    GetAllServiceDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ServiceApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllServiceDtoToJson(GetAllServiceDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };

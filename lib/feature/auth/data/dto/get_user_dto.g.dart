// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDto _$GetUserDtoFromJson(Map<String, dynamic> json) => GetUserDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => UserApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUserDtoToJson(GetUserDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };

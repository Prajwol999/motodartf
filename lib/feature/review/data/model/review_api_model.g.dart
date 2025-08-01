// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewApiModel _$ReviewApiModelFromJson(Map<String, dynamic> json) =>
    ReviewApiModel(
      id: json['_id'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      bookingId: json['booking'] as String,
      service: json['service'] as String?,
      user: json['user'] == null
          ? null
          : UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewApiModelToJson(ReviewApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'booking': instance.bookingId,
      if (instance.service case final value?) 'service': value,
      if (instance.user case final value?) 'user': value,
    };

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/review_entity.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel {
  @JsonKey(name: 'rating')
  final double rating;
  
  @JsonKey(name: 'comment')
  final String comment;

  @JsonKey(name: 'bookingId')
  final String bookingId;

  ReviewApiModel({
    required this.rating,
    required this.comment,
    required this.bookingId,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  // Convert Entity to Model for sending data to API
  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      rating: entity.rating,
      comment: entity.comment,
      bookingId: entity.bookingId,
    );
  }
}
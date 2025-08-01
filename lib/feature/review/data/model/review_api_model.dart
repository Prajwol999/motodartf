
import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/auth/data/model/user_api_model.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel {
  @JsonKey(name: '_id')
  final String? id; // Nullable as it doesn't exist when creating

  final double rating;
  final String comment;

  @JsonKey(name: 'booking')
  final String bookingId; // Use 'booking' to match the backend model when fetching

  @JsonKey(includeIfNull: false)
  final String? service; // Nullable, as it's part of the response

  @JsonKey(includeIfNull: false)
  final UserApiModel? user; // Nullable, as it's part of the response

  ReviewApiModel({
    this.id,
    required this.rating,
    required this.comment,
    required this.bookingId,
    this.service,
    this.user,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    // Custom toJson to only include fields needed for creation
    return {
      'rating': rating,
      'comment': comment,
      'bookingId': bookingId,
    };
  }

  // Convert API Model to Entity
  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      rating: rating,
      comment: comment,
      bookingId: bookingId,
      serviceId: service,
      user: user?.toEntity(),
    );
  }

  // Convert Entity to Model for sending data to API
  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      rating: entity.rating,
      comment: entity.comment,
      bookingId: entity.bookingId!, // bookingId is required for creation
    );
  }
}
import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart';
import 'user_api_model.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final UserApiModel user;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewApiModel({
    this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id ?? '',
      user: user.toEntity(),
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }

  static List<ReviewEntity> toEntityList(List<ReviewApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
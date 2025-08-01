import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String? profilePicture;

  UserApiModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      profilePicture: profilePicture ?? '', email: '', password: '',
    );
  }
}
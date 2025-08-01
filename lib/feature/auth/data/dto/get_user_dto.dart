import 'package:json_annotation/json_annotation.dart';

import '../model/user_api_model.dart';

part 'get_user_dto.g.dart';
@JsonSerializable()
class GetUserDto {
  final bool success;
  final int count;
  final List<UserApiModel> data;

  const GetUserDto({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetUserDto.fromJson(Map<String, dynamic> json) =>
      _$GetUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDtoToJson(this);
}
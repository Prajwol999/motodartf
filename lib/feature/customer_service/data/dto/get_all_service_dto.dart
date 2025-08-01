import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/customer_service/data/model/service_api_model.dart';


part 'get_all_service_dto.g.dart';
@JsonSerializable()
class GetAllServiceDto {
 final bool success ;
  final int? count;
  final List<ServiceApiModel> data;

  const GetAllServiceDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllServiceDtoToJson(this);

  factory GetAllServiceDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllServiceDtoFromJson(json);
}
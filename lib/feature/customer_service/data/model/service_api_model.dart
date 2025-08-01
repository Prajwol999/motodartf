// lib/features/customer_service/data/model/service_api_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';

part 'service_api_model.g.dart';

@JsonSerializable()
class ServiceApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? serviceId;
  final String name;
  final String description;
  final double price;
  final String? duration;

  const ServiceApiModel({
    this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    this.duration,
  });

  @override
  List<Object?> get props => [serviceId, name, description, price, duration];

  const ServiceApiModel.empty()
      : serviceId = "",
        name = "",
        description = "",
        price = 0,
        duration = "";

  factory ServiceApiModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceApiModelToJson(this);

  ServiceEntity toEntity() {
    return ServiceEntity(
      serviceId: serviceId,
      name: name,
      description: description,
      price: price,
      duration: duration,
    );
  }

  static ServiceApiModel fromEntity(ServiceEntity entity) {
    return ServiceApiModel(
      serviceId: entity.serviceId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      duration: entity.duration,
    );
  }

  static List<ServiceEntity> toEntityList(
    List<ServiceApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}

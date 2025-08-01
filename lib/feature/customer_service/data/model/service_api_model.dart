import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/reviews/data/model/review_api_model.dart';

part 'service_api_model.g.dart';

@JsonSerializable()
class ServiceApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? serviceId;
  final String name;
  final String description;
  final double price;
  final String? duration;
  // --- NEW FIELDS ---
  final List<ReviewApiModel>? reviews;
  final double? averageRating;
  final int? numberOfReviews;

  const ServiceApiModel({
    this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    this.duration,
    // --- NEW FIELDS ---
    this.reviews,
    this.averageRating,
    this.numberOfReviews,
  });

  @override
  List<Object?> get props => [
        serviceId,
        name,
        description,
        price,
        duration,
        reviews,
        averageRating,
        numberOfReviews,
      ];

  const ServiceApiModel.empty()
      : serviceId = "",
        name = "",
        description = "",
        price = 0,
        duration = "",
        reviews = const [],
        averageRating = 0.0,
        numberOfReviews = 0;

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
      // --- NEW FIELDS ---
      reviews: reviews != null ? ReviewApiModel.toEntityList(reviews!) : [],
      averageRating: averageRating ?? 0.0,
      numberOfReviews: numberOfReviews ?? 0,
    );
  }

  static ServiceApiModel fromEntity(ServiceEntity entity) {
    return ServiceApiModel(
      serviceId: entity.serviceId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      duration: entity.duration,
      // --- NEW FIELDS ---
      // Note: We don't typically map reviews back from entity to API model for sending data
      reviews: const [], 
      averageRating: entity.averageRating,
      numberOfReviews: entity.numberOfReviews,
    );
  }

  static List<ServiceEntity> toEntityList(
    List<ServiceApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
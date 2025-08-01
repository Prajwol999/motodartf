import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/reviews/domain/entity/review_entity.dart'; // Import the new entity

class ServiceEntity extends Equatable {
  final String? serviceId;
  final String name;
  final String description;
  final double price;
  final String? duration;
  // --- NEW FIELDS ---
  final List<ReviewEntity> reviews;
  final double averageRating;
  final int numberOfReviews;

  const ServiceEntity({
    this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    this.duration,
    // --- NEW FIELDS ---
    required this.reviews,
    required this.averageRating,
    required this.numberOfReviews,
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
}
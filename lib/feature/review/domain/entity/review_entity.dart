import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

class ReviewEntity extends Equatable {
  final String? id; // The review's own ID from the database
  final double rating;
  final String comment;
  final String? bookingId; // Used for creating a review
  final String? serviceId; // The service this review is for
  final UserEntity? user; // The user who wrote the review

  const ReviewEntity({
    this.id,
    required this.rating,
    required this.comment,
    this.bookingId,
    this.serviceId,
    this.user,
  });

  @override
  List<Object?> get props => [id, rating, comment, bookingId, serviceId, user];
}
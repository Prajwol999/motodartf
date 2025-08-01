import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/reviews/domain/entity/user_entity.dart';

class ReviewEntity extends Equatable {
  final String? id;
  final UserEntity? user;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  // These are needed when creating a review from the app
  final String? bookingId;
  final String? serviceId;

  const ReviewEntity({
    this.id,
    this.user,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.bookingId,
    this.serviceId,
  });

  @override
  List<Object?> get props => [id, user, rating, comment, createdAt, bookingId, serviceId];
}
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String profilePicture;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [id, fullName, profilePicture];
}
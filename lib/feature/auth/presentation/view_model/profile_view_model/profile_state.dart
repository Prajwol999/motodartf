import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';

class ProfileState extends Equatable {
  final bool? isLoading;
  final String? onError;
  final UserEntity? userEntity;
  final bool? isEditing;
  final bool? isProfileDeleted;
  final bool? isLoggedOut;

  const ProfileState({
    this.isLoading,
    this.onError,
    this.userEntity,
    this.isEditing,
    this.isProfileDeleted,
    this.isLoggedOut,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      onError: null,
      userEntity: null,
      isEditing: false,
      isProfileDeleted: false,
      isLoggedOut: false,
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    String? onError,
    UserEntity? userEntity,
    bool? isEditing,
    bool? isProfileDeleted,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      onError: onError,
      userEntity: userEntity ?? this.userEntity,
      isEditing: isEditing ?? this.isEditing,
      isProfileDeleted: isProfileDeleted ?? this.isProfileDeleted,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        onError,
        userEntity,
        isEditing,
        isProfileDeleted,
        isLoggedOut,
      ];
}

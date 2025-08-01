import 'package:equatable/equatable.dart';

import '../../../domain/entity/auth_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class ToggleEditModeEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final UserEntity userEntity;

  const UpdateProfileEvent({required this.userEntity});

  @override
  List<Object?> get props => [userEntity];
}

class DeleteProfileEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

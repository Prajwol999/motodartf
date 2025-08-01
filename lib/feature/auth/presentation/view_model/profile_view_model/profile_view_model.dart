import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/auth/domain/use_case/user_logout_usecase.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';

import '../../../domain/use_case/user_delete_usecase.dart';
import '../../../domain/use_case/user_get_usecase.dart';
import '../../../domain/use_case/user_update_usecase.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetUseCase _userGetUseCase;
  final UserUpdateUsecase _userUpdateUsecase;
  final UserDeleteUsecase _userDeleteUsecase;
  final UserLogoutUseCase _userLogoutUseCase;

  ProfileViewModel({
    required UserGetUseCase userGetUseCase,
    required UserUpdateUsecase userUpdateUseCase,
    required UserDeleteUsecase userDeleteUsecase,
    required UserLogoutUseCase userLogoutUseCase,
  })  : _userDeleteUsecase = userDeleteUsecase,
        _userUpdateUsecase = userUpdateUseCase,
        _userGetUseCase = userGetUseCase,
        _userLogoutUseCase = userLogoutUseCase,
        super(ProfileState.initial()) {
    on<LoadProfileEvent>(_onProfileLoad);
    on<DeleteProfileEvent>(_onProfileDelete);
    on<UpdateProfileEvent>(_onProfileUpdate);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<LogoutEvent>(_onLogout);

    add(LoadProfileEvent());
  }

  Future<void> _onProfileLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userGetUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, onError: failure.message)),
      (user) {
        emit(
          state.copyWith(isLoading: false, userEntity: user, isEditing: false),
        );
      },
    );
  }

  void _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isEditing: !(state.isEditing ?? false)));
  }

  Future<void> _onProfileDelete(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userDeleteUsecase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, onError: failure.message)),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            isProfileDeleted: true,
            userEntity: null,
          ),
        );
      },
    );
  }

  Future<void> _onProfileUpdate(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userUpdateUsecase(event.userEntity);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, onError: failure.message));
      },
      (updatedUser) {
        emit(
          state.copyWith(
            isLoading: false,
            userEntity: updatedUser,
            isEditing: false,
          ),
        );
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLogoutUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, onError: failure.message)),
      (_) {
        // On success, emit the logged out state
        emit(state.copyWith(isLoading: false, isLoggedOut: true));
      },
    );
  }
}

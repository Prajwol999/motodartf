import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:motofix_app/feature/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_event.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  NotificationViewModel({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkNotificationsAsRead>(_onMarkNotificationsAsRead);
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> _onMarkNotificationsAsRead(
    MarkNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await markAsReadUseCase();
    result.fold(
      (failure) {
        // Optionally emit an error state if marking as read fails
      },
      (_) {
        // After successfully marking as read, fetch the updated list
        add(FetchNotifications());
      },
    );
  }
}
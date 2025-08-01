import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/notification/data/model/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

// Initial state, before any data is fetched
class NotificationInitial extends NotificationState {}

// State when notifications are being loaded from the backend
class NotificationLoading extends NotificationState {}

// State when notifications have been successfully loaded
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

// State when an error occurs
class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}
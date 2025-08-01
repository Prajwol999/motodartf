import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all notifications
class FetchNotifications extends NotificationEvent {}

// Event to mark all notifications as read
class MarkNotificationsAsRead extends NotificationEvent {}
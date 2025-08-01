import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/notification/data/model/notification_model.dart';
import 'package:motofix_app/feature/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final INotificationRepository repository;

  GetNotificationsUseCase({required this.repository});

  Future<Either<Failure, List<NotificationModel>>> call() async {
    return await repository.getNotifications();
  }
}
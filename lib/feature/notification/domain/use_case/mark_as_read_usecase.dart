import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/notification/domain/repository/notification_repository.dart';

class MarkAsReadUseCase {
  final INotificationRepository repository;

  MarkAsReadUseCase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.markAsRead();
  }
}
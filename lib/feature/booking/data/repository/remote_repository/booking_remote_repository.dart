import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';

import '../../../domain/entity/booking_entity.dart';
import '../../../domain/repository/booking_repository.dart';
import '../../data_source/remote_data_source/remote_booking_data_source.dart';

class BookingRemoteRepository implements BookingRepository {
  final RemoteBookingDataSource _remoteBookingDataSource;

  BookingRemoteRepository({
    required RemoteBookingDataSource remoteBookingDataSource,
  }) : _remoteBookingDataSource = remoteBookingDataSource;

  @override
  Future<Either<Failure, BookingEntity>> confirmCodPayment(String bookingId) {
    // TODO: implement confirmCodPayment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> createBooking(
      BookingEntity entity, String? token) async {
    try {
      await _remoteBookingDataSource.createBooking(entity, token);
      return Right(null);
    } catch (e) {
      return left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserBooking(
      String bookingId, String? token) async {
    try {
      await _remoteBookingDataSource.deleteUserBooking(bookingId, token);
      return const Right(null);
    } catch (e) {
      return left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(
      String? token) async {
    try {
      final bookings = await _remoteBookingDataSource.getUserBooking(token);
      return Right(bookings);
    } catch (e) {
      return left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> updateUserBooking(String bookingId) {
    // TODO: implement updateUserBooking
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> verifyKhaltiPayment() {
    // TODO: implement verifyKhaltiPayment
    throw UnimplementedError();
  }
}

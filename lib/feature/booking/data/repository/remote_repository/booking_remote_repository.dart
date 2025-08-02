import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';
import 'package:motofix_app/feature/booking/domain/repository/booking_repository.dart';
import 'package:motofix_app/feature/booking/data/data_source/remote_data_source/remote_booking_data_source.dart';

class BookingRemoteRepository implements BookingRepository {
  final RemoteBookingDataSource _remoteBookingDataSource;

  BookingRemoteRepository({
    required RemoteBookingDataSource remoteBookingDataSource,
  }) : _remoteBookingDataSource = remoteBookingDataSource;

  @override
  Future<Either<Failure, void>> createBooking(
      BookingEntity entity, String? token) async {
    try {
      await _remoteBookingDataSource.createBooking(entity, token);
      // Use 'const Right(null)' for void returns. It's slightly more performant.
      return const Right(null);
    } catch (e) {
      // Use 'Left' consistently. 'left' is a function, 'Left' is the class constructor.
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserBooking(
      String bookingId, String? token) async {
    try {
      await _remoteBookingDataSource.deleteUserBooking(bookingId, token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(
      String? token) async {
    try {
      // Matches the method name in your remote data source.
      final bookings = await _remoteBookingDataSource.getUserBooking(token);
      return Right(bookings);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getCompletedBookings(
      String? token) async {
    try {
      final bookings = await _remoteBookingDataSource.getCompletedBookings(token);
      return Right(bookings);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(
      String bookingId, String? token) async {
    try {
      final booking =
          await _remoteBookingDataSource.getBookingById(bookingId, token);
      return Right(booking);
    } catch (e) {
      return Left(ApiFailure(statusCode: 500, message: e.toString()));
    }
  }

  // --- Unimplemented Methods ---
  // It's good practice to provide a clear message in unimplemented methods.

  @override
  Future<Either<Failure, BookingEntity>> confirmCodPayment(String bookingId) {
    // TODO: implement confirmCodPayment
    throw UnimplementedError('confirmCodPayment has not been implemented yet.');
  }

  @override
  Future<Either<Failure, BookingEntity>> updateUserBooking(String bookingId) {
    // TODO: implement updateUserBooking
    throw UnimplementedError('updateUserBooking has not been implemented yet.');
  }

  @override
  Future<Either<Failure, void>> verifyKhaltiPayment() {
    // TODO: implement verifyKhaltiPayment
    throw UnimplementedError('verifyKhaltiPayment has not been implemented yet.');
  }
}
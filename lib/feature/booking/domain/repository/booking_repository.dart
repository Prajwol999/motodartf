import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';

import '../entity/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(String? token);
  Future<Either<Failure, void>> createBooking(
      BookingEntity entity, String? token);
  Future<Either<Failure, BookingEntity>> updateUserBooking(String bookingId);
  Future<Either<Failure, void>> deleteUserBooking(
      String bookingId, String? token);
  Future<Either<Failure, BookingEntity>> confirmCodPayment(String bookingId);
  Future<Either<Failure, void>> verifyKhaltiPayment();
  Future<Either<Failure, List<BookingEntity>>> getCompletedBookings(String? token); 
  Future<Either<Failure, BookingEntity>> getBookingById(String bookingId, String? token);
}

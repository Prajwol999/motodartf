import '../../domain/entity/booking_entity.dart';

abstract class BookingDataSource {
  Future<List<BookingEntity>> getUserBooking(String? token);
  Future<void> createBooking(BookingEntity entity, String? token);
  Future<void> deleteUserBooking(String bookingId, String? token);
}

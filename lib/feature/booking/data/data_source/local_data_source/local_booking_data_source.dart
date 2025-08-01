import 'package:motofix_app/core/network/hive_service.dart';

import '../../../domain/entity/booking_entity.dart';
import '../booking_data_source.dart';

class LocalBookingDataSource implements BookingDataSource {
  final HiveService _hiveService;

  LocalBookingDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> createBooking(BookingEntity entity, String? token) {
    // TODO: implement createBooking
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUserBooking(String bookingId, String? token) {
    // TODO: implement deleteUserBooking
    throw UnimplementedError();
  }

  @override
  Future<List<BookingEntity>> getUserBooking(String? token) async {
    // TODO: implement getUserBooking
    throw UnimplementedError();
  }
}

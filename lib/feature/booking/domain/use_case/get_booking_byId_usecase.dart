import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';

import '../entity/booking_entity.dart';
import '../repository/booking_repository.dart';

class GetBookingByIdUseCase implements UseCaseWithParams<BookingEntity, String> {
  final BookingRepository bookingRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  GetBookingByIdUseCase({required this.bookingRepository, required this.tokenSharedPrefs});

  @override
  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => bookingRepository.getBookingById(bookingId, token),
    );
  }
}
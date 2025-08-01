import 'package:dartz/dartz.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';

import '../entity/booking_entity.dart';
import '../repository/booking_repository.dart';

class GetCompletedBookingsUseCase implements UseCaseWithoutParams<List<BookingEntity>> {
  final BookingRepository bookingRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  GetCompletedBookingsUseCase({required this.bookingRepository, required this.tokenSharedPrefs});

  @override
  Future<Either<Failure, List<BookingEntity>>> call() async {
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => bookingRepository.getCompletedBookings(token),
    );
  }
}
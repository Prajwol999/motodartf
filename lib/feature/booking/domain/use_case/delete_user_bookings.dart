import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';

import '../repository/booking_repository.dart';

class DeleteBookingParams extends Equatable {
  final String bookingId;

  const DeleteBookingParams({required this.bookingId});

  const DeleteBookingParams.empty() : bookingId = '_empty.string';

  @override
  // TODO: implement props
  List<Object?> get props => [bookingId];
}

class DeleteBookingUsecase
    implements UseCaseWithParams<void, DeleteBookingParams> {
  final BookingRepository bookingRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  DeleteBookingUsecase({
    required this.bookingRepository,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, void>> call(DeleteBookingParams params) async {
    final token = await tokenSharedPrefs.getToken();
    if (token == null) {
      return Left(
          ApiFailure(message: 'User not authenticated.', statusCode: 403));
    }
    return bookingRepository.deleteUserBooking(
        params.bookingId, token as String?);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';
import '../repository/booking_repository.dart';

class DeleteBookingParams extends Equatable {
  final String bookingId;

  const DeleteBookingParams({required this.bookingId});

  @override
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
    // First, get the authentication token result
    final tokenResult = await tokenSharedPrefs.getToken();

    // Use .fold() to handle both possible outcomes (failure or success)
    return tokenResult.fold(
      // This function runs if getToken() returned a Left (failure)
      (failure) {
        return Left(failure);
      },
      // This function runs if getToken() returned a Right (success)
      (token) async {
        // Now 'token' is the actual String value
        if (token == null || token.isEmpty) {
          return Left(
            ApiFailure(message: 'User not authenticated.', statusCode: 401),
          );
        }
        
        // With the valid token, call the repository to delete the booking
        return await bookingRepository.deleteUserBooking(params.bookingId, token);
      },
    );
  }
}
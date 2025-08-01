import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';

import '../entity/booking_entity.dart';
import '../repository/booking_repository.dart';

class CreateBookingParams extends Equatable {
  final String serviceId;
  final String bikeModel;
  final DateTime date;
  final String? notes;
  CreateBookingParams(
      {required this.serviceId,
      required this.bikeModel,
      required this.date,
      this.notes});
  @override
  // TODO: implement props
  List<Object?> get props => [bikeModel, date, notes, serviceId];
}

class CreateBookingUseCase
    implements UseCaseWithParams<void, CreateBookingParams> {
  final BookingRepository bookingRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  CreateBookingUseCase(
      {required this.bookingRepository, required this.tokenSharedPrefs});

  @override
  Future<Either<Failure, void>> call(CreateBookingParams params) async {
    final tokenResult = await tokenSharedPrefs.getToken();

    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async {
        final bookingEntity = BookingEntity(
          // Map fields from 'params' to 'BookingEntity'
          bikeModel: params.bikeModel, // <-- Use the data!
          date: params.date, // <-- Use the data!
          notes: params.notes, // <-- Use the data!

          serviceType: params.serviceId, // <-- Use the data!

          customerName: null, // The server might get this from the token
          status: 'pending', // A good default value
          paymentStatus: 'unpaid', // A good default value
          // etc. for other fields...
        );

        // Now you are passing a fully populated entity to the repository
        return await bookingRepository.createBooking(
          bookingEntity,
          token,
        );
      },
    );
  }
}

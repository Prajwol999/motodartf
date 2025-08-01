import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/app/shared_pref/token_shared_prefs.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

import '../entity/booking_entity.dart';
import '../repository/booking_repository.dart';

class CreateBookingParams extends Equatable {
  final String serviceId;
  final String bikeModel;
  final DateTime date;
  final String? notes;
  final double totalCost; // Added totalCost

  const CreateBookingParams(required String bikeModel, {
    required this.serviceId,
    required this.bikeModel,
    required this.date,
    this.notes,
    required this.totalCost, // Added totalCost
  });

  @override
  List<Object?> get props => [serviceId, bikeModel, date, notes, totalCost];
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
        // Create a complete BookingEntity with default or provided values
        final bookingEntity = BookingEntity(
          id: const Uuid().v4(), // Generate a unique ID for the new booking
          customerName: '', // Server will populate this from the token
          serviceType: params.serviceId,
          bikeModel: params.bikeModel,
          date: params.date,
          notes: params.notes ?? '',
          totalCost: params.totalCost,
          status: 'Pending', // Default status for a new booking
          paymentStatus: 'Pending', // Default payment status
          isPaid: false, // Default payment state
          paymentMethod: 'Not Selected', // Default payment method
          isReviewed: false, // A new booking is never reviewed
        );

        // Pass the fully populated entity to the repository
        return await bookingRepository.createBooking(
          bookingEntity,
          token,
        );
      },
    );
  }
}
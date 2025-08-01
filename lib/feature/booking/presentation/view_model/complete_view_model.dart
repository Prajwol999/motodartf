// lib/feature/booking/presentation/view_model/complete_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';
import 'package:motofix_app/feature/booking/domain/use_case/get_booking_byId_usecase.dart';
import 'package:motofix_app/feature/booking/domain/use_case/get_completed_booking_usecase.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';

// You will need to create and import your BookingEntity



class BookingHistoryBloc extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  final GetCompletedBookingsUseCase _getCompletedBookingsUseCase;
  final GetBookingByIdUseCase _getBookingByIdUseCase;

  BookingHistoryBloc({
    required GetCompletedBookingsUseCase getCompletedBookingsUseCase,
    required GetBookingByIdUseCase getBookingByIdUseCase,
  })  : _getCompletedBookingsUseCase = getCompletedBookingsUseCase,
        _getBookingByIdUseCase = getBookingByIdUseCase,
        super(BookingHistoryInitial()) {
    on<FetchCompletedBookingsList>(_onFetchCompletedBookingsList);
    on<FetchBookingDetailsById>(_onFetchBookingDetailsById);
  }

  /// Handles fetching the entire list of completed bookings.
  Future<void> _onFetchCompletedBookingsList(
    FetchCompletedBookingsList event,
    Emitter<BookingHistoryState> emit,
  ) async {
    emit(BookingHistoryListLoading());
    final result = await _getCompletedBookingsUseCase();
    result.fold(
      (failure) => emit(BookingHistoryFailure(failure.message)),
      (bookings) => emit(BookingHistoryListLoaded(bookings)),
    );
  }

  /// Handles fetching the details of a single booking.
  Future<void> _onFetchBookingDetailsById(
    FetchBookingDetailsById event,
    Emitter<BookingHistoryState> emit,
  ) async {
    // Get the current list from the state, if it exists.
    // This is crucial for preserving the list in the background.
    List<BookingEntity> currentBookings = [];
    if (state is BookingHistoryWithData) {
      currentBookings = (state as BookingHistoryWithData).bookings;
    }

    final result = await _getBookingByIdUseCase(event.bookingId);
    result.fold(
      (failure) => emit(BookingHistoryFailure(failure.message)),
      (bookingDetail) {
        // After successfully fetching details, update the item in the master list.
        // This is useful if details changed (e.g., a review was submitted).
        final updatedBookings = currentBookings.map((b) {
          return b.id == bookingDetail.id ? bookingDetail : b;
        }).toList();

        // Emit the detail loaded state, containing both the specific detail
        // and the updated master list.
        emit(BookingHistoryDetailLoaded(
          booking: bookingDetail,
          bookings: updatedBookings,
        ));
      },
    );
  }
}
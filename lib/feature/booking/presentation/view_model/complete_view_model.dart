import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/domain/use_case/get_booking_byId_usecase.dart';
import 'package:motofix_app/feature/booking/domain/use_case/get_completed_booking_usecase.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/complete_state.dart';


class BookingHistoryBloc extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  // The BLoC now depends on both use cases.
  final GetCompletedBookingsUseCase _getCompletedBookingsUseCase;
  final GetBookingByIdUseCase _getBookingByIdUseCase;

  BookingHistoryBloc({
    required GetCompletedBookingsUseCase getCompletedBookingsUseCase,
    required GetBookingByIdUseCase getBookingByIdUseCase,
  })  : _getCompletedBookingsUseCase = getCompletedBookingsUseCase,
        _getBookingByIdUseCase = getBookingByIdUseCase,
        super(BookingHistoryInitial()) {

    // Register the handler for fetching the list.
    on<FetchCompletedBookingsList>(_onFetchCompletedBookingsList);

    // Register the handler for fetching the details.
    on<FetchBookingDetailsById>(_onFetchBookingDetailsById);
  }

  /// Handles the logic for fetching the entire list of completed bookings.
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

  /// Handles the logic for fetching the details of a single booking.
  Future<void> _onFetchBookingDetailsById(
    FetchBookingDetailsById event,
    Emitter<BookingHistoryState> emit,
  ) async {
    emit(BookingHistoryDetailLoading());
    final result = await _getBookingByIdUseCase(event.bookingId);
    result.fold(
      (failure) => emit(BookingHistoryFailure(failure.message)),
      (booking) => emit(BookingHistoryDetailLoaded(booking)),
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_state.dart';

import '../../domain/entity/booking_entity.dart';
import '../../domain/use_case/create_user_bookings.dart';
import '../../domain/use_case/delete_user_bookings.dart';
import '../../domain/use_case/get_user_bookings.dart';
import 'booking_event.dart';

class BookingViewModel extends Bloc<BookingEvent, BookingState> {
  final GetUserBookings _getUserBookingsUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final DeleteBookingUsecase _deleteBookingUseCase;

  BookingViewModel({
    required GetUserBookings getUserBookingsUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required DeleteBookingUsecase deleteBookingUseCase,
  })  : _getUserBookingsUseCase = getUserBookingsUseCase,
        _createBookingUseCase = createBookingUseCase,
        _deleteBookingUseCase = deleteBookingUseCase,
        super(BookingInitial()) {
    on<LoadUserBookingsEvent>(_onLoadUserBookings);
    on<CreateBookingEvent>(_onCreateBooking);
    on<DeleteBookingEvent>(_onDeleteBooking);
  }

  void _onLoadUserBookings(
    LoadUserBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await _getUserBookingsUseCase();
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (bookings) => emit(BookingLoadSuccess(bookings)),
    );
  }

  void _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    // This loading state is for the button on the CreateBookingScreen
    emit(BookingLoading());

    final params = CreateBookingParams(
      bikeModel: event.bikeModel,
      date: event.date,
      notes: event.notes,
      serviceId: event.serviceId,
    );

    final result = await _createBookingUseCase(params);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (createdBooking) {
        // Emit a success message for the CreateBookingScreen listener.
        emit(const BookingActionSuccess('Booking Created Successfully!'));
        // Trigger a reload on the BookingPage, which will be visible after navigation.
        add(LoadUserBookingsEvent());
      },
    );
  }

  // --- REFACTORED METHOD ---
  void _onDeleteBooking(
    DeleteBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    // Show a loading indicator on the whole page while deleting and refetching.
    emit(BookingLoading());
    final params = DeleteBookingParams(bookingId: event.bookingId);
    final deleteResult = await _deleteBookingUseCase(params);

    await deleteResult.fold(
      // If deletion fails, emit a failure state.
      (failure) async => emit(BookingFailure(failure.message)),
      // If deletion succeeds, immediately refetch the list.
      (_) async {
        final getResult = await _getUserBookingsUseCase();
        getResult.fold(
          (failure) => emit(BookingFailure(failure.message)),
          // Emit ONE state that contains both the new data and the success message.
          (bookings) => emit(BookingLoadSuccess(
            bookings,
            successMessage: 'Booking Deleted Successfully!',
          )),
        );
      },
    );
  }
}

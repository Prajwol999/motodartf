import 'package:bloc/bloc.dart';
import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';
import 'package:motofix_app/feature/booking/domain/use_case/create_user_bookings.dart';
import 'package:motofix_app/feature/booking/domain/use_case/delete_user_bookings.dart';
import 'package:motofix_app/feature/booking/domain/use_case/get_user_bookings.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_event.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_state.dart';

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

  /// Handles the initial loading of all user bookings from the repository.
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

  /// Handles the creation of a new booking.
  void _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    // Optionally emit a loading state if the creation process is long
    // emit(BookingLoading());

    final params = CreateBookingParams(
      bikeModel: event.bikeModel,
      date: event.date,
      notes: event.notes,
      serviceId: event.serviceId,
    );

    final result = await _createBookingUseCase(params);
    result.fold(
      (failure) {
        // On failure, emit a general failure state. The UI can show this error.
        emit(BookingFailure(failure.message));
      },
      (_) {
        // On success, emit the specific action success state.
        // The UI can listen for this to pop the screen or show a success dialog.
        emit(const BookingActionSuccess('Booking Created Successfully!'));
        // After success, trigger a reload of the main bookings list.
        add(LoadUserBookingsEvent());
      },
    );
  }

  /// Handles deleting a booking using an "Optimistic UI" approach.
  /// The UI updates instantly, and reverts only if the server call fails.
  void _onDeleteBooking(
    DeleteBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    // Get the current state to access the list of bookings.
    final currentState = state;

    // This logic only runs if we have a list of bookings already loaded.
    if (currentState is BookingLoadSuccess) {
      // 1. Create a mutable copy of the current list.
      final List<BookingEntity> updatedBookings =
          List.from(currentState.bookings);

      // 2. Find the booking to remove.
      final int bookingIndex =
          updatedBookings.indexWhere((booking) => booking.id == event.bookingId);

      // Proceed only if the booking was found in the list.
      if (bookingIndex != -1) {
        // --- Step A: Optimistic Update ---
        // Remove the booking from our local list.
        final bookingToRemove = updatedBookings.removeAt(bookingIndex);

        // Immediately emit the new state with the shortened list.
        // The UI will update instantly, feeling very responsive.
        emit(BookingLoadSuccess(updatedBookings));

        // --- Step B: Server Call ---
        // Now, attempt the actual deletion on the server.
        final deleteResult = await _deleteBookingUseCase(
          DeleteBookingParams(bookingId: event.bookingId),
        );

        // --- Step C: Handle Server Response ---
        deleteResult.fold(
          (failure) {
            // FAILURE CASE: The server failed to delete the booking.
            // Re-insert the removed booking into our list at its original position.
            updatedBookings.insert(bookingIndex, bookingToRemove);

            // Emit the success state again, but this time with the restored list
            // AND an error message for the UI to display (e.g., in a SnackBar).
            emit(BookingLoadSuccess(
              updatedBookings,
              error: 'Failed to delete: ${failure.message}',
            ));
          },
          (_) {
            // SUCCESS CASE: The server confirmed the deletion.
            // The UI is already correct. We just emit a new state
            // with a success message for the UI to optionally show a SnackBar.
            emit(BookingLoadSuccess(
              updatedBookings,
              successMessage: 'Booking was deleted successfully.',
            ));
          },
        );
      }
    }
    // If the state is not BookingLoadSuccess, we do nothing.
    // A delete action shouldn't be possible from a loading or error screen.
  }
}
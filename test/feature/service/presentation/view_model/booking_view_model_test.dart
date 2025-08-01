// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:motofix_app/core/error/failure.dart';
// import 'package:motofix_app/feature/booking/domain/entity/booking_entity.dart';
// import 'package:motofix_app/feature/booking/domain/use_case/create_user_bookings.dart';
// import 'package:motofix_app/feature/booking/domain/use_case/delete_user_bookings.dart';
// import 'package:motofix_app/feature/booking/domain/use_case/get_user_bookings.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_event.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_state.dart';
// import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
//
//
// // 1. Mocks for all external dependencies
// class MockGetUserBookings extends Mock implements GetUserBookings {}
//
// class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}
//
// class MockDeleteBookingUseCase extends Mock implements DeleteBookingUsecase {}
//
// // 2. Fakes for complex parameter objects
// class FakeCreateBookingParams extends Fake implements CreateBookingParams {}
//
// class FakeDeleteBookingParams extends Fake implements DeleteBookingParams {}
//
// class FakeBookingEntity extends Fake implements BookingEntity {}
//
// // ... (imports from above)
//
// void main() {
//   // Late initialization for all mocks and the ViewModel
//   late BookingViewModel bookingViewModel;
//   late MockGetUserBookings mockGetUserBookings;
//   late MockCreateBookingUseCase mockCreateBookingUseCase;
//   late MockDeleteBookingUseCase mockDeleteBookingUseCase;
//
//   // Dummy data for testing
//   final tBooking = BookingEntity(
//     id: '1',
//     customerName: 'Test User',
//     serviceType: 'Oil Change',
//     bikeModel: 'Yamaha R15',
//     date: DateTime.now(),
//     notes: 'Check brakes',
//     totalCost: 50.0,
//     status: 'Scheduled',
//     paymentStatus: 'Pending',
//     isPaid: false,
//     paymentMethod: 'Cash',
//   );
//   final tBookingList = [tBooking];
//
//   // This runs once before all tests
//   setUpAll(() {
//     // Register fallback values for fake objects
//     registerFallbackValue(FakeCreateBookingParams());
//     registerFallbackValue(FakeDeleteBookingParams());
//     registerFallbackValue(FakeBookingEntity());
//   });
//
//   // This runs before each test to ensure a clean slate
//   setUp(() {
//     mockGetUserBookings = MockGetUserBookings();
//     mockCreateBookingUseCase = MockCreateBookingUseCase();
//     mockDeleteBookingUseCase = MockDeleteBookingUseCase();
//     bookingViewModel = BookingViewModel(
//       getUserBookingsUseCase: mockGetUserBookings,
//       createBookingUseCase: mockCreateBookingUseCase,
//       deleteBookingUseCase: mockDeleteBookingUseCase,
//     );
//   });
//
//   // This runs after each test to close the BLoC stream
//   tearDown(() {
//     bookingViewModel.close();
//   });
//
//   // Test the initial state
//   test('initial state should be BookingInitial', () {
//     expect(bookingViewModel.state, BookingInitial());
//   });
//
//   group('LoadUserBookingsEvent', () {
//     // Test the SUCCESS path
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingLoading, BookingLoadSuccess] when data is fetched successfully',
//       // Arrange: Stub the use case to return a successful result
//       setUp: () {
//         when(() => mockGetUserBookings())
//             .thenAnswer((_) async => Right(tBookingList));
//       },
//       // Act: Add the event
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(LoadUserBookingsEvent()),
//       // Assert: Check the sequence of emitted states
//       expect: () => [
//         BookingLoading(),
//         BookingLoadSuccess(tBookingList),
//       ],
//       // Verify: Ensure the use case was called
//       verify: (_) {
//         verify(() => mockGetUserBookings()).called(1);
//       },
//     );
//
//     // Test the FAILURE path
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingLoading, BookingFailure] when fetching data fails',
//       // Arrange: Stub the use case to return a failure
//       setUp: () {
//         when(() => mockGetUserBookings()).thenAnswer((_) async =>
//             Left(ApiFailure(message: 'Server Error', statusCode: 500)));
//       },
//       // Act: Add the event
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(LoadUserBookingsEvent()),
//       // Assert: Check the sequence of emitted states
//       expect: () => [
//         BookingLoading(),
//         const BookingFailure('Server Error'),
//       ],
//     );
//   });
//
//   group('CreateBookingEvent', () {
//     // Test the SUCCESS path for creating a booking
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingActionSuccess, BookingLoading, BookingLoadSuccess] when a booking is created successfully',
//       // Arrange: Stub both create and get use cases for the full flow
//       setUp: () {
//         when(() => mockCreateBookingUseCase(any()))
//             .thenAnswer((_) async => const Right(null));
//         when(() => mockGetUserBookings())
//             .thenAnswer((_) async => Right(tBookingList));
//       },
//       // Act: Add the event with a booking entity
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(CreateBookingEvent(tBooking = '', serviceId: '', bikeModel: '', date: null)),
//       // Assert: The final state should be a successful load after the action
//       expect: () => [
//         const BookingActionSuccess('Booking Created Successfully!'),
//         BookingLoading(),
//         BookingLoadSuccess(tBookingList),
//       ],
//       // Verify: Check that the create use case was called
//       verify: (_) {
//         verify(() => mockCreateBookingUseCase(any(
//             that: isA<CreateBookingParams>()
//                 .having((p) => p.customerName, 'customerName',
//                     tBooking.customerName)
//                 .having((p) => p.serviceType, 'serviceType',
//                     tBooking.serviceType)))).called(1);
//         // Verify that the list is reloaded
//         verify(() => mockGetUserBookings()).called(1);
//       },
//     );
//
//     // Test the FAILURE path for creating a booking
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingFailure] when creating a booking fails',
//       setUp: () {
//         when(() => mockCreateBookingUseCase(any())).thenAnswer((_) async =>
//             Left(ApiFailure(message: 'Creation Failed', statusCode: 500)));
//       },
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(CreateBookingEvent(tBooking)),
//       expect: () => [
//         const BookingFailure('Creation Failed'),
//       ],
//     );
//   });
//
//   group('DeleteBookingEvent', () {
//     const bookingId = '1';
//
//     // Test the SUCCESS path for deleting a booking
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingActionSuccess, BookingLoading, BookingLoadSuccess] when a booking is deleted successfully',
//       // Arrange: Stub both delete and get use cases
//       setUp: () {
//         when(() => mockDeleteBookingUseCase(any()))
//             .thenAnswer((_) async => const Right(null));
//         when(() => mockGetUserBookings()).thenAnswer(
//             (_) async => Right([])); // Return an empty list after deletion
//       },
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(const DeleteBookingEvent(bookingId: bookingId)),
//       expect: () => [
//         const BookingActionSuccess('Booking Deleted Successfully!'),
//         BookingLoading(),
//         const BookingLoadSuccess([]),
//       ],
//       verify: (_) {
//         verify(() => mockDeleteBookingUseCase(
//             const DeleteBookingParams(bookingId: bookingId))).called(1);
//         verify(() => mockGetUserBookings()).called(1);
//       },
//     );
//
//     // Test the FAILURE path for deleting a booking
//     blocTest<BookingViewModel, BookingState>(
//       'should emit [BookingFailure] when deleting a booking fails',
//       setUp: () {
//         when(() => mockDeleteBookingUseCase(any())).thenAnswer((_) async =>
//             Left(ApiFailure(message: 'Deletion Failed', statusCode: 500)));
//       },
//       build: () => bookingViewModel,
//       act: (bloc) => bloc.add(const DeleteBookingEvent(bookingId: bookingId)),
//       expect: () => [
//         const BookingFailure('Deletion Failed'),
//       ],
//     );
//   });
// }

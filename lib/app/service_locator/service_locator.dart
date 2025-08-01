// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:motofix_app/core/network/api_service.dart';
// import 'package:motofix_app/core/network/hive_service.dart';
// import 'package:motofix_app/feature/auth/data/data_source/remote_data_source/remote_data_source.dart';
// import 'package:motofix_app/feature/auth/data/repository/remote_user_repository.dart';
// import 'package:motofix_app/feature/auth/domain/use_case/checkout_user_status_usecase.dart';
// import 'package:motofix_app/feature/auth/domain/use_case/login_use_case.dart';
// import 'package:motofix_app/feature/auth/domain/use_case/register_use_case.dart';
// import 'package:motofix_app/feature/auth/domain/use_case/user_logout_usecase.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
// import 'package:motofix_app/feature/customer_service/data/data_source/remote_data_source/service_remote_data_source.dart';
// import 'package:motofix_app/feature/customer_service/data/repository/remote_repository/service_remote_repository.dart';
// import 'package:motofix_app/feature/customer_service/domain/usecase/get_all_services_usecase.dart';
// import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
// import 'package:motofix_app/feature/notification/data/data_source/notification_remote_data_source.dart';
// import 'package:motofix_app/feature/notification/data/repository/notification_repository_impl.dart';
// import 'package:motofix_app/feature/notification/domain/repository/notification_repository.dart';
// import 'package:motofix_app/feature/notification/domain/use_case/get_notifications_usecase.dart';
// import 'package:motofix_app/feature/notification/domain/use_case/mark_as_read_usecase.dart';
// import 'package:motofix_app/feature/notification/presentation/view_model/notification_view_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../feature/auth/domain/use_case/user_delete_usecase.dart';
// import '../../feature/auth/domain/use_case/user_get_usecase.dart';
// import '../../feature/auth/domain/use_case/user_update_usecase.dart';
// import '../../feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
// import '../../feature/booking/data/data_source/remote_data_source/remote_booking_data_source.dart';
// import '../../feature/booking/data/repository/remote_repository/booking_remote_repository.dart';
// import '../../feature/booking/domain/repository/booking_repository.dart';
// import '../../feature/booking/domain/use_case/create_user_bookings.dart';
// import '../../feature/booking/domain/use_case/delete_user_bookings.dart';
// import '../../feature/booking/domain/use_case/get_user_bookings.dart';
// import '../../feature/booking/presentation/view_model/booking_view_model.dart';
// import '../shared_pref/token_shared_prefs.dart';

// final serviceLocator = GetIt.instance;

// Future initDependencies() async {
//   await _initHiveService();
//   await _initSharedPrefs();
//   await _initApiService();
//   await _initAuthModule();
//   await _initBookingModule();
//   await _initServiceModule();
//   await _initNotificationModule(); // New module added
// }

// Future _initHiveService() async {
//   serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
// }

// Future _initApiService() async {
//   // Pass the Dio instance configured with the interceptor
//   serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));
// }


// Future<void> _initSharedPrefs() async {
//   final sharedPrefs = await SharedPreferences.getInstance();
//   serviceLocator.registerLazySingleton(() => sharedPrefs);
//   serviceLocator.registerLazySingleton(
//     () => TokenSharedPrefs(
//       sharedPreferences: serviceLocator<SharedPreferences>(),
//     ),
//   );
// }

// Future<void> _initAuthModule() async {
//   // ===================== Data Source ====================
//   serviceLocator.registerFactory(
//       () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()));

//   // ===================== Repository ====================
//   serviceLocator.registerFactory(
//     () => UserRemoteRepository(
//         userRemoteDataSource: serviceLocator<UserRemoteDataSource>()),
//   );

//   // ===================== Use Cases ====================
//   serviceLocator.registerFactory(
//     () => UserLoginUseCase(
//         userRepository: serviceLocator<UserRemoteRepository>(),
//         tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
//   );

//   serviceLocator.registerFactory(
//     () => UserRegisterUseCase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => UserGetUseCase(
//       iUserRepository: serviceLocator<UserRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => UserUpdateUsecase(
//       iUserRepository: serviceLocator<UserRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => UserDeleteUsecase(
//       iUserRepository: serviceLocator<UserRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );

//   serviceLocator.registerFactory(() =>
//       CheckAuthStatusUseCase(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));

//   serviceLocator.registerFactory(
//       () => UserLogoutUseCase(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));

//   // ===================== ViewModels ====================
//   serviceLocator.registerFactory<RegisterViewModel>(
//     () => RegisterViewModel(serviceLocator<UserRegisterUseCase>()),
//   );

//   serviceLocator.registerFactory(
//     () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
//   );

//   serviceLocator.registerFactory(
//     () => ProfileViewModel(
//       userGetUseCase: serviceLocator<UserGetUseCase>(),
//       userUpdateUseCase: serviceLocator<UserUpdateUsecase>(),
//       userDeleteUsecase: serviceLocator<UserDeleteUsecase>(),
//       userLogoutUseCase: serviceLocator<UserLogoutUseCase>(),
//     ),
//   );
// }

// Future<void> _initBookingModule() async {
//   // ===================== Data Source ====================
//   serviceLocator.registerFactory<RemoteBookingDataSource>(
//     () => RemoteBookingDataSource(apiService: serviceLocator<ApiService>()),
//   );

//   // ===================== Repository ====================
//   serviceLocator.registerFactory<BookingRemoteRepository>(
//     () => BookingRemoteRepository(
//       remoteBookingDataSource: serviceLocator<RemoteBookingDataSource>(),
//     ),
//   );
  
//   // This registration seems incorrect as it depends on itself.
//   // It should likely be registering the implementation (BookingRemoteRepository)
//   // for the abstract class (BookingRepository).
//   // I am assuming you want to register BookingRemoteRepository for the BookingRepository interface.
//   serviceLocator.registerFactory<BookingRepository>(
//       () => serviceLocator<BookingRemoteRepository>());

//   // ===================== Use Cases ====================
//   serviceLocator.registerFactory(() => GetUserBookings(
//       bookingRepository: serviceLocator<BookingRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));
//   serviceLocator.registerFactory(
//     () => DeleteBookingUsecase(
//       bookingRepository: serviceLocator<BookingRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => CreateBookingUseCase(
//         bookingRepository: serviceLocator<BookingRemoteRepository>(),
//         tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
//   );

//   // ===================== ViewModel (BLoC) ====================
//   serviceLocator.registerFactory<BookingViewModel>(
//     () => BookingViewModel(
//       getUserBookingsUseCase: serviceLocator<GetUserBookings>(),
//       deleteBookingUseCase: serviceLocator<DeleteBookingUsecase>(),
//       createBookingUseCase: serviceLocator<CreateBookingUseCase>(),
//     ),
//   );
// }

// Future<void> _initServiceModule() async {
//   // ===================== Data Source ====================
//   serviceLocator.registerFactory(
//     () => ServiceRemoteDataSource(apiService: serviceLocator<ApiService>()),
//   );
  
//   // ===================== Repository ====================
//   serviceLocator.registerFactory<ServiceRemoteRepository>(
//     () => ServiceRemoteRepository(
//       serviceRemoteDataSource: serviceLocator<ServiceRemoteDataSource>(),
//     ),
//   );

//   // ===================== Use Cases ====================
//   serviceLocator.registerFactory(
//     () => GetAllServicesUsecase(
//       serviceRepository: serviceLocator<ServiceRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );

//   // ===================== ViewModel ====================
//   serviceLocator.registerFactory<ServiceViewModel>(
//     () => ServiceViewModel(
//       getAllServicesUsecase: serviceLocator<GetAllServicesUsecase>(),
//     ),
//   );
// }

// Future<void> _initNotificationModule() async {
//   // ===================== Data Source ====================
//   serviceLocator.registerFactory(
//     () => NotificationRemoteDataSource(dio: serviceLocator<ApiService>().dio),
//   );

//   // ===================== Repository ====================
//   // Register the implementation for the interface
//   serviceLocator.registerFactory<INotificationRepository>(
//     () => NotificationRepositoryImpl(
//       remoteDataSource: serviceLocator<NotificationRemoteDataSource>(),
//     ),
//   );

//   // ===================== Use Cases ====================
//   serviceLocator.registerFactory(
//     () => GetNotificationsUseCase(
//       repository: serviceLocator<INotificationRepository>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => MarkAsReadUseCase(
//       repository: serviceLocator<INotificationRepository>(),
//     ),
//   );

//   // ===================== ViewModel (BLoC) ====================
//   serviceLocator.registerFactory<NotificationViewModel>(
//     () => NotificationViewModel(
//       getNotificationsUseCase: serviceLocator<GetNotificationsUseCase>(),
//       markAsReadUseCase: serviceLocator<MarkAsReadUseCase>(),
//     ),
//   );
// }


import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/core/network/hive_service.dart';
import 'package:motofix_app/feature/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:motofix_app/feature/auth/data/repository/remote_user_repository.dart';
import 'package:motofix_app/feature/auth/domain/use_case/checkout_user_status_usecase.dart';
import 'package:motofix_app/feature/auth/domain/use_case/login_use_case.dart';
import 'package:motofix_app/feature/auth/domain/use_case/register_use_case.dart';
import 'package:motofix_app/feature/auth/domain/use_case/user_logout_usecase.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:motofix_app/feature/customer_service/data/data_source/remote_data_source/service_remote_data_source.dart';
import 'package:motofix_app/feature/customer_service/data/repository/remote_repository/service_remote_repository.dart';
import 'package:motofix_app/feature/customer_service/domain/usecase/get_all_services_usecase.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';
import 'package:motofix_app/feature/notification/data/data_source/notification_remote_data_source.dart';
import 'package:motofix_app/feature/notification/data/repository/notification_repository_impl.dart';
import 'package:motofix_app/feature/notification/domain/repository/notification_repository.dart';
import 'package:motofix_app/feature/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:motofix_app/feature/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_view_model.dart';
import 'package:motofix_app/feature/splash/view_model/spash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/domain/use_case/user_delete_usecase.dart';
import '../../feature/auth/domain/use_case/user_get_usecase.dart';
import '../../feature/auth/domain/use_case/user_update_usecase.dart';
import '../../feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import '../../feature/booking/data/data_source/remote_data_source/remote_booking_data_source.dart';
import '../../feature/booking/data/repository/remote_repository/booking_remote_repository.dart';
import '../../feature/booking/domain/repository/booking_repository.dart';
import '../../feature/booking/domain/use_case/create_user_bookings.dart';
import '../../feature/booking/domain/use_case/delete_user_bookings.dart';
import '../../feature/booking/domain/use_case/get_user_bookings.dart';
import '../../feature/booking/presentation/view_model/booking_view_model.dart';
import '../shared_pref/token_shared_prefs.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initSharedPrefs();
  await _initApiService();
  await _initAuthModule();
  await _initBookingModule();
  await _initServiceModule();
  await _initNotificationModule();
  await _initSplashModule();
}

Future _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future _initApiService() async {
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));
}

Future<void> _initSharedPrefs() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory(
      () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()));

  // Repository
  serviceLocator.registerFactory(
    () => UserRemoteRepository(
        userRemoteDataSource: serviceLocator<UserRemoteDataSource>()),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => UserLoginUseCase(
        userRepository: serviceLocator<UserRemoteRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetUseCase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserUpdateUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserDeleteUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(() =>
      CheckAuthStatusUseCase(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));

  serviceLocator.registerFactory(
      () => UserLogoutUseCase(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));

  // ViewModels
  serviceLocator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(serviceLocator<UserRegisterUseCase>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUseCase>()),
  );

  serviceLocator.registerFactory(
    () => ProfileViewModel(
      userGetUseCase: serviceLocator<UserGetUseCase>(),
      userUpdateUseCase: serviceLocator<UserUpdateUsecase>(),
      userDeleteUsecase: serviceLocator<UserDeleteUsecase>(),
      userLogoutUseCase: serviceLocator<UserLogoutUseCase>(),
    ),
  );
}

Future<void> _initBookingModule() async {
  // Data Source
  serviceLocator.registerFactory<RemoteBookingDataSource>(
    () => RemoteBookingDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory<BookingRemoteRepository>(
    () => BookingRemoteRepository(
      remoteBookingDataSource: serviceLocator<RemoteBookingDataSource>(),
    ),
  );
  
  serviceLocator.registerFactory<BookingRepository>(
      () => serviceLocator<BookingRemoteRepository>());

  // Use Cases
  serviceLocator.registerFactory(() => GetUserBookings(
      bookingRepository: serviceLocator<BookingRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));
  serviceLocator.registerFactory(
    () => DeleteBookingUsecase(
      bookingRepository: serviceLocator<BookingRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => CreateBookingUseCase(
        bookingRepository: serviceLocator<BookingRemoteRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  // ViewModel (BLoC)
  serviceLocator.registerFactory<BookingViewModel>(
    () => BookingViewModel(
      getUserBookingsUseCase: serviceLocator<GetUserBookings>(),
      deleteBookingUseCase: serviceLocator<DeleteBookingUsecase>(),
      createBookingUseCase: serviceLocator<CreateBookingUseCase>(),
    ),
  );
}

Future<void> _initServiceModule() async {
  // Data Source
  serviceLocator.registerFactory(
    () => ServiceRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  
  // Repository
  serviceLocator.registerFactory<ServiceRemoteRepository>(
    () => ServiceRemoteRepository(
      serviceRemoteDataSource: serviceLocator<ServiceRemoteDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => GetAllServicesUsecase(
      serviceRepository: serviceLocator<ServiceRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // ViewModel
  serviceLocator.registerFactory<ServiceViewModel>(
    () => ServiceViewModel(
      getAllServicesUsecase: serviceLocator<GetAllServicesUsecase>(),
    ),
  );
}

Future<void> _initNotificationModule() async {
  // Data Source
  serviceLocator.registerFactory(
    () => NotificationRemoteDataSource(dio: serviceLocator<ApiService>().dio),
  );

  // Repository
  serviceLocator.registerFactory<INotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: serviceLocator<NotificationRemoteDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => GetNotificationsUseCase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => MarkAsReadUseCase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );

  // ViewModel (BLoC)
  serviceLocator.registerFactory<NotificationViewModel>(
    () => NotificationViewModel(
      getNotificationsUseCase: serviceLocator<GetNotificationsUseCase>(),
      markAsReadUseCase: serviceLocator<MarkAsReadUseCase>(),
    ),
  );
}

Future<void> _initSplashModule() async {
  // ViewModel (Cubit)
  serviceLocator.registerFactory<SplashCubit>(
    () => SplashCubit(
      checkAuthStatusUseCase: serviceLocator<CheckAuthStatusUseCase>(),
    ),
  );
}
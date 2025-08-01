import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/domain/usecase/get_all_services_usecase.dart';
import 'repository_mock.dart';
import 'token_mock.dart';

void main() {
  late MockServiceRepository repository;
  late GetAllServicesUsecase usecase;
  late MockTokenSharedPrefs tokenSharedPrefs; // Use this instance

  setUp(() {
    repository = MockServiceRepository();
    // 1. Initialize the mock instance here
    tokenSharedPrefs = MockTokenSharedPrefs();

    // 2. Pass the initialized mock instance to the usecase
    usecase = GetAllServicesUsecase(
      serviceRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  // Test data
  const token = 'fake_token';

  final tService = ServiceEntity(
      name: 'test service',
      description: 'test description',
      price: 0,
      duration: 'test duration');

  final tService2 = ServiceEntity(
      name: 'test service2',
      description: 'test description2',
      price: 11,
      duration: 'test duration2');

  final tServices = [tService, tService2];

  test('should get all services from the repository when token is available',
      () async {
    // Arrange
    // 3. STUB THE getToken() METHOD! This is the most important fix.
    //    Tell the mock what to return when getToken() is called.
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right(token));

    // 4. Stub the repository call. This part was already correct.
    when(() => repository.getAllServices(token))
        .thenAnswer((_) async => Right(tServices));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tServices));

    // Verify that the methods were called in the correct order.
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.getAllServices(token)).called(1);

    verifyNoMoreInteractions(tokenSharedPrefs);
    verifyNoMoreInteractions(repository);
  });

  // BONUS: Add a test for the failure case
  test('should return a Failure when getting the token fails', () async {
    // Arrange
    // Stub the getToken() method to return a Failure
    final tFailure = ApiFailure(statusCode: 500, message: '');
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(tFailure));

    // Verify that only getToken was called. The repository should NOT be called.
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verifyNoMoreInteractions(tokenSharedPrefs);
    verifyZeroInteractions(repository);
  });
}

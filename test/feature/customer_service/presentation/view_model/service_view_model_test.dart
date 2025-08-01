import 'dart:developer';
import 'dart:ffi';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/domain/usecase/get_all_services_usecase.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_state.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';

class MockGetAllServiceUseCase extends Mock implements GetAllServicesUsecase {}

void main() {
  late GetAllServicesUsecase getAllServicesUsecase;
  late ServiceViewModel serviceViewModel;

  setUp(() {
    getAllServicesUsecase = MockGetAllServiceUseCase();

    serviceViewModel =
        ServiceViewModel(getAllServicesUsecase: getAllServicesUsecase);
  });
  tearDown(() {
    serviceViewModel.close();
  });

  group('Service View model', () {
    final service = ServiceEntity(
        name: 'test',
        description: 'test description',
        price: 111,
        duration: 'test duration');
    final service2 = ServiceEntity(
        name: 'test 2',
        description: 'test description 2',
        price: 222,
        duration: 'test duration 2');

    final tServices = [service2, service];

    blocTest<ServiceViewModel, ServiceState>(
      'emits [loading, success] when GetAllServicesEvent is added and usecase returns data.',
      build: () {
        when(() => getAllServicesUsecase.call())
            .thenAnswer((_) async => Right(tServices));

        return serviceViewModel;
      },
      act: (bloc) => bloc.add(GetAllServicesEvent()),
      expect: () => <ServiceState>[
        const ServiceState(status: ServiceStatus.loading),
        ServiceState(status: ServiceStatus.success, services: tServices),
      ],
      verify: (_) {
        verify(() => getAllServicesUsecase.call()).called(1);
        verifyNoMoreInteractions(getAllServicesUsecase);
      },
    );

    blocTest<ServiceViewModel, ServiceState>(
      'emits [loading, failure] when GetAllServicesEvent is failed.',
      build: () {
        when(() => getAllServicesUsecase.call()).thenAnswer(
            (_) async => Left(ApiFailure(statusCode: 500, message: 'Error')));

        return serviceViewModel;
      },
      act: (bloc) => bloc.add(GetAllServicesEvent()),
      expect: () => <ServiceState>[
        const ServiceState(status: ServiceStatus.loading),
        ServiceState(status: ServiceStatus.failure),
      ],
      verify: (_) {
        verify(() => getAllServicesUsecase.call()).called(1);
        verifyNoMoreInteractions(getAllServicesUsecase);
      },
    );
  });

  testWidgets('service view model ...', (tester) async {
    // TODO: Implement test
  });
}

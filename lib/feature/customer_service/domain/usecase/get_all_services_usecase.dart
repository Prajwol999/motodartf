import 'package:dartz/dartz.dart';
import 'package:motofix_app/app/usecase/usecase.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/domain/repository/service_repository.dart';

import '../../../../app/shared_pref/token_shared_prefs.dart';
import '../../../../core/error/failure.dart';


class GetAllServicesUsecase
    implements UseCaseWithoutParams<List<ServiceEntity>> {
  final IServiceRepository _serviceRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetAllServicesUsecase({
    required IServiceRepository serviceRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _serviceRepository = serviceRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<ServiceEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
          (failure) => Left(failure),
          (tokenValue) =>
          _serviceRepository.getAllServices(tokenValue),
    );
  }
}
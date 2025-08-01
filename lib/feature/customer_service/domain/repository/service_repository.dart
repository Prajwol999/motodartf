
import 'package:dartz/dartz.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';

import '../../../../core/error/failure.dart';

abstract interface class IServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getAllServices(
      String? token,
      );
}

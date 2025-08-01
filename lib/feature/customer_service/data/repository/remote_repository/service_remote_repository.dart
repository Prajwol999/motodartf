import 'package:dartz/dartz.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/customer_service/data/data_source/remote_data_source/service_remote_data_source.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/domain/repository/service_repository.dart';

class ServiceRemoteRepository implements IServiceRepository {
  final ServiceRemoteDataSource _serviceRemoteDataSource ;
  
  ServiceRemoteRepository({
    required ServiceRemoteDataSource serviceRemoteDataSource ,
}) : _serviceRemoteDataSource = serviceRemoteDataSource ;

  @override
  Future<Either<Failure, List<ServiceEntity>>> getAllServices(String? token) async {
    try {
      final services =  await _serviceRemoteDataSource.getService(token) ;
      return Right(services) ;
    }
    catch(e){
     return Left(ApiFailure(message: e.toString(), statusCode: 500)) ;
    }

  }
}
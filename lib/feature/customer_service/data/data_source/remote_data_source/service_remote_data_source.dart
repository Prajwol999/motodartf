import 'package:dio/dio.dart';
import 'package:motofix_app/app/constant/api_endpoints.dart';
import 'package:motofix_app/core/network/api_service.dart';
import 'package:motofix_app/feature/customer_service/data/data_source/service_data_source.dart';
import 'package:motofix_app/feature/customer_service/data/dto/get_all_service_dto.dart';
import 'package:motofix_app/feature/customer_service/data/model/service_api_model.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';

class ServiceRemoteDataSource implements IServiceDataSource {
  final ApiService _apiService ;

  ServiceRemoteDataSource({
    required ApiService apiService ,
}) : _apiService = apiService ;

  @override
  Future<List<ServiceEntity>> getService(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllServices
      ) ;

      print('Service remote data source $response') ;
      if(response.statusCode == 200){
        GetAllServiceDto getAllServiceDto = GetAllServiceDto.fromJson(response.data) ;

        return ServiceApiModel.toEntityList(
          getAllServiceDto.data ,
        ) ;
      } else {
        throw Exception('Failed to fetch services : ${response.statusMessage}') ;

      }

    }
     on DioException catch(e){
      throw Exception('Failed to fetch services $e') ;
      
     }
    catch(e){
      throw Exception ('An unexpected error occurred : $e') ;
    }

  }


}
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';

abstract interface class IServiceDataSource {
  Future<List<ServiceEntity>> getService(String? token) ;
}
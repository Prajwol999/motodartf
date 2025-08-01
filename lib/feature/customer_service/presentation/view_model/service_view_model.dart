import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/domain/usecase/get_all_services_usecase.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_state.dart';



class ServiceViewModel extends Bloc<ServiceEvent, ServiceState> {
  final GetAllServicesUsecase _getAllServicesUsecase;

  ServiceViewModel({
    required GetAllServicesUsecase getAllServicesUsecase,
  })  : _getAllServicesUsecase = getAllServicesUsecase,
        super(const ServiceState()) {
    // Register the event handler
    on<GetAllServicesEvent>(_onGetAllServices);
  }

  Future<void> _onGetAllServices(
      GetAllServicesEvent event,
      Emitter<ServiceState> emit,
      ) async {

    emit(state.copyWith(status: ServiceStatus.loading));

    final result = await _getAllServicesUsecase();


    result.fold(
          (failure) {
        emit(state.copyWith(
          status: ServiceStatus.failure,

        ));
      }, (serviceList) {
        emit(state.copyWith(
          status: ServiceStatus.success,
          services: serviceList,
        ));
      },
    );
  }
}
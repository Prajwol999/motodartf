import 'package:equatable/equatable.dart';


abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

// Event dispatched to get all available services
class GetAllServicesEvent extends ServiceEvent {}
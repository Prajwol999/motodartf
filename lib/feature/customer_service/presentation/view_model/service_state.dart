

import 'package:equatable/equatable.dart';

import '../../domain/entity/service_entity.dart';

enum ServiceStatus { initial, loading, success, failure }

class ServiceState extends Equatable {
  final ServiceStatus status;
  final List<ServiceEntity> services;
  final String errorMessage;

  const ServiceState({
    this.status = ServiceStatus.initial,
    this.services = const <ServiceEntity>[],
    this.errorMessage = '',
  });

  // A copyWith method to easily create a new state from the old one
  ServiceState copyWith({
    ServiceStatus? status,
    List<ServiceEntity>? services,
    String? errorMessage,
  }) {
    return ServiceState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, services, errorMessage];
}
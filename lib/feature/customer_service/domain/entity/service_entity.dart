import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String? serviceId ;
  final String name ;
  final String description ;
  final double price ;
  final String? duration ;

  ServiceEntity({
    this.serviceId ,
    required this.name ,
    required this.description ,
    required this.price ,
    required this.duration ,
}) ;

  @override
  // TODO: implement props
  List<Object?> get props => [serviceId ,name , description , price ,duration];
}
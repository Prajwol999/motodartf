import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class LocalDataBaseFailure extends Failure {
  const LocalDataBaseFailure({required super.message});
}

class ApiFailure extends Failure {
  final int statusCode;

  const ApiFailure({required this.statusCode, required super.message});
}

class SharedPreferencesFailure extends Failure {
  const SharedPreferencesFailure({required super.message});
}

// --- ADD THIS CLASS ---
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}
// --------------------
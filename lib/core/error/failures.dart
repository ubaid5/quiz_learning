import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super(message: message ?? 'Server error occurred');
}

class CacheFailure extends Failure {
  const CacheFailure({String? message})
      : super(message: message ?? 'Cache error occurred');
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(message: message ?? 'Network error occurred');
}

class ValidationFailure extends Failure {
  const ValidationFailure({String? message})
      : super(message: message ?? 'Validation error occurred');
}



import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Future<Stream<Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

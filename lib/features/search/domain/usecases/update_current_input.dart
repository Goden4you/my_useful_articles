import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/search/domain/repositories/search_repository.dart';

class UpdateCurrentInput implements UseCase<String, UpdateCurrentInputParams> {
  final SearchRepository repository;

  UpdateCurrentInput(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateCurrentInputParams params) {
    return repository.updateCurrentInput(input: params.input);
  }
}

class UpdateCurrentInputParams extends Equatable {
  final String input;

  UpdateCurrentInputParams({this.input}) : assert(input != null);

  @override
  List get props => [input];
}

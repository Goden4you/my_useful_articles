import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';
import 'package:selfDevelopment/features/search/domain/repositories/search_repository.dart';

class AddSearchInput implements UseCase<SearchInput, AddSearchInputParams> {
  final SearchRepository repository;

  AddSearchInput(this.repository);

  @override
  Future<Either<Failure, SearchInput>> call(AddSearchInputParams params) {
    return repository.addSearchInput(input: params.input);
  }
}

class AddSearchInputParams extends Equatable {
  final String input;

  AddSearchInputParams({this.input}) : assert(input != null);

  @override
  List get props => [input];
}

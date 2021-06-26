import 'package:dartz/dartz.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';
import 'package:selfDevelopment/features/search/domain/repositories/search_repository.dart';

class GetAllSearches implements UseCase<List<SearchInput>, NoParams> {
  final SearchRepository repository;

  GetAllSearches(this.repository);

  @override
  Future<Either<Failure, List<SearchInput>>> call(NoParams params) {
    return repository.getAllSearches();
  }
}

import 'package:dartz/dartz.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchInput>>> getAllSearches();
  Future<Either<Failure, SearchInput>> addSearchInput({String input});
  Future<Either<Failure, String>> updateCurrentInput({String input});
  // Future<Either<Failure, void>> clearSearchHistory();
}

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/search/data/datasources/search_local_datasources.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';
import 'package:selfDevelopment/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchesLocalDataSources searchesLocalDataSources;

  SearchRepositoryImpl({@required this.searchesLocalDataSources});

  @override
  Future<Either<Failure, List<SearchInput>>> getAllSearches() async {
    try {
      final result = await searchesLocalDataSources.getAllSearches();

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, SearchInput>> addSearchInput({String input}) async {
    try {
      final result = await searchesLocalDataSources.addSearchInput(
        input: input,
      );

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, String>> updateCurrentInput({String input}) async {
    try {
      final result = await searchesLocalDataSources.updateCurrentInput(
        input: input,
      );

      return Right(result);
    } catch (e) {
      return null;
    }
  }
}

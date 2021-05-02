import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class AddArticle implements UseCase<Article, AddArticleParams> {
  final ArticlesRepository repository;

  AddArticle(
    this.repository,
  );

  @override
  Future<Either<Failure, Article>> call(AddArticleParams params) async {
    return repository.addArticle(params.title, params.body);
  }
}

class AddArticleParams extends Equatable {
  final String title;
  final String body;

  AddArticleParams(this.title, this.body) : assert(title != null, body != null);

  @override
  List<Object> get props => [title, body];
}
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/articles/data/datasources/articles_local_datasources.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesLocalDataSources articlesLocalDataSources;

  ArticlesRepositoryImpl({@required this.articlesLocalDataSources});

  @override
  Future<Either<Failure, List<Article>>> getAllArticles() async {
    try {
      final result = await articlesLocalDataSources.getAllArticles();

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Article>> addArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status}) async {
    try {
      final result = await articlesLocalDataSources.addArticle(
          id: id,
          title: title,
          body: body,
          image: image,
          folder: folder,
          status: status);

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Article>> removeArticle(Article article) async {
    try {
      final result = await articlesLocalDataSources.removeArticle(article);

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Article>> markArticleAsReaded(Article article) async {
    try {
      final result =
          await articlesLocalDataSources.markArticleAsReaded(article);

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Article>> markArticleAsUnreaded(
      Article article) async {
    try {
      final result =
          await articlesLocalDataSources.markArticleAsUnreaded(article);

      return Right(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Article>> editArticle(
      {int id,
      String title,
      String body,
      String image,
      ArticleStatus status,
      String folder}) async {
    try {
      final result = await articlesLocalDataSources.editArticle(
          id: id,
          title: title,
          body: body,
          image: image,
          folder: folder,
          status: status);

      return Right(result);
    } catch (e) {
      return null;
    }
  }
}

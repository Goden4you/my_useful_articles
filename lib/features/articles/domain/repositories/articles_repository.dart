import 'package:dartz/dartz.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> getAllArticles();
  Future<Either<Failure, Article>> addArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status});
  Future<Either<Failure, Article>> removeArticle(Article article);
  Future<Either<Failure, Article>> markArticleAsReaded(Article article);
  Future<Either<Failure, Article>> markArticleAsUnreaded(Article article);
  Future<Either<Failure, Article>> editArticle(
      {int id,
      String title,
      String body,
      String image,
      ArticleStatus status,
      String folder});
}

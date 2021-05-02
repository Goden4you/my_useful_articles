import 'package:dartz/dartz.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> getAllArticles();
  Future<Either<Failure, Article>> addArticle(String title, String body);
  Future<Either<Failure, Article>> removeArticle(Article article);
  Future<Either<Failure, Article>> markArticleAsReaded(Article article);
}

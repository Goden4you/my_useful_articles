import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class MarkArticleAsReaded
    implements UseCase<Article, MarkArticleAsReadedParams> {
  final ArticlesRepository repository;

  MarkArticleAsReaded(
    this.repository,
  );

  @override
  Future<Either<Failure, Article>> call(
      MarkArticleAsReadedParams params) async {
    return repository.markArticleAsReaded(params.article);
  }
}

class MarkArticleAsReadedParams extends Equatable {
  final Article article;

  MarkArticleAsReadedParams(this.article) : assert(article != null);

  @override
  List<Object> get props => [article];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class MarkArticleAsUnreaded
    implements UseCase<Article, MarkArticleAsUnreadedParams> {
  final ArticlesRepository repository;

  MarkArticleAsUnreaded(
    this.repository,
  );

  @override
  Future<Either<Failure, Article>> call(
      MarkArticleAsUnreadedParams params) async {
    return repository.markArticleAsUnreaded(params.article);
  }
}

class MarkArticleAsUnreadedParams extends Equatable {
  final Article article;

  MarkArticleAsUnreadedParams(this.article) : assert(article != null);

  @override
  List<Object> get props => [article];
}

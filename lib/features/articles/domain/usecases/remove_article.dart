import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class RemoveArticle implements UseCase<Article, RemoveArticleParams> {
  final ArticlesRepository repository;

  RemoveArticle(
    this.repository,
  );

  @override
  Future<Either<Failure, Article>> call(RemoveArticleParams params) async {
    return repository.removeArticle(params.article);
  }
}

class RemoveArticleParams extends Equatable {
  final Article article;

  RemoveArticleParams(this.article) : assert(article != null);

  @override
  List<Object> get props => [article];
}

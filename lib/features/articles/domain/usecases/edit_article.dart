import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class EditArticle implements UseCase<Article, EditArticleParams> {
  final ArticlesRepository repository;

  EditArticle(
    this.repository,
  );

  @override
  Future<Either<Failure, Article>> call(EditArticleParams params) async {
    return repository.editArticle(
        id: params.id,
        title: params.title,
        body: params.body,
        image: params.image,
        folder: params.folder,
        status: params.status);
  }
}

class EditArticleParams extends Equatable {
  final int id;
  final String title;
  final String body;
  final String image;
  final String folder;
  final ArticleStatus status;

  EditArticleParams(
      {this.id, this.title, this.body, this.image, this.folder, this.status});

  @override
  List<Object> get props => [id, title, body, image, folder, status];
}

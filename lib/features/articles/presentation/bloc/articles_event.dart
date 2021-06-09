import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

class GetAllArticlesRequested extends ArticlesEvent {}

class AddArticleRequested extends ArticlesEvent {
  final String title;
  final String body;
  final String image;
  final String folder;
  final ArticleStatus status;

  AddArticleRequested(
      {this.title, this.body, this.image, this.folder, this.status});
  @override
  List<Object> get props => [title, body, image, folder, status];
}

class RemoveArticleRequested extends ArticlesEvent {
  final Article article;

  RemoveArticleRequested(this.article);
  @override
  List<Object> get props => [article];
}

class MarkArticleAsReadedRequested extends ArticlesEvent {
  final Article article;

  MarkArticleAsReadedRequested(this.article);
  @override
  List<Object> get props => [article];
}

class MarkArticleAsUnReadedRequested extends ArticlesEvent {
  final Article article;

  MarkArticleAsUnReadedRequested(this.article);
  @override
  List<Object> get props => [article];
}

class EditArticleRequested extends ArticlesEvent {
  final int id;
  final String title;
  final String body;
  final String image;
  final ArticleStatus status;
  final String folder;

  EditArticleRequested(
      {this.id, this.title, this.body, this.image, this.status, this.folder});
  @override
  List<Object> get props => [id, title, body, image, status, folder];
}

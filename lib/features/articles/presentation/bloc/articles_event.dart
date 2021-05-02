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

  AddArticleRequested(this.title, this.body);
  @override
  List<Object> get props => [title, body];
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

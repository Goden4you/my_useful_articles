import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

enum ArticlesStatus { empty, loading, success, failure }

class ArticlesState extends Equatable {
  final ArticlesStatus status;
  final List<Article> articles;
  final Failure failure;

  const ArticlesState.empty() : this._();

  const ArticlesState._(
      {this.status = ArticlesStatus.empty, this.articles, this.failure});

  ArticlesState copyWith(
          {ArticlesStatus status, List<Article> articles, Failure failure}) =>
      ArticlesState._(
        status: status ?? this.status,
        articles: articles ?? this.articles,
        failure: failure ?? this.failure,
      );

  @override
  List<Object> get props => [status, articles, failure];
}

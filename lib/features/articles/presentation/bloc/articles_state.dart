import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

enum ArticlesStatus { empty, loading, success, failure }

class ArticlesState extends Equatable {
  final ArticlesStatus status;
  final List<Article> articles;
  final Failure failure;
  final List<String> existingFolders;

  const ArticlesState.empty() : this._();

  const ArticlesState._(
      {this.status = ArticlesStatus.empty,
      this.articles,
      this.failure,
      this.existingFolders});

  ArticlesState copyWith(
          {ArticlesStatus status,
          List<Article> articles,
          Failure failure,
          List<String> existingFolders}) =>
      ArticlesState._(
          status: status ?? this.status,
          articles: articles ?? this.articles,
          failure: failure ?? this.failure,
          existingFolders: existingFolders ?? this.existingFolders);

  @override
  List<Object> get props => [status, articles, failure, existingFolders];
}

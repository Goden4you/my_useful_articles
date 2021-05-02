import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/config.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/add_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/get_all_articles.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_readed.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/remove_article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetAllArticles getAllArticles;
  final AddArticle addArticle;
  final RemoveArticle removeArticle;
  final MarkArticleAsReaded markArticleAsReaded;

  ArticlesBloc(
      {@required this.getAllArticles,
      @required this.addArticle,
      @required this.removeArticle,
      @required this.markArticleAsReaded})
      : super(ArticlesState.empty());

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    if (event is GetAllArticlesRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticles = await getAllArticles(NoParams());

      yield* _eitherArticlesOrNot(failureOrArticles);
    }

    if (event is AddArticleRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticleAdded =
          await addArticle(AddArticleParams(event.title, event.body));
      yield* _eitherArticleAddedRemovedOrNot(failureOrArticleAdded, false);
    }

    if (event is RemoveArticleRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticleRemoved =
          await removeArticle(RemoveArticleParams(event.article));
      yield* _eitherArticleAddedRemovedOrNot(failureOrArticleRemoved, true);
    }

    if (event is MarkArticleAsReadedRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticleReaded =
          await markArticleAsReaded(MarkArticleAsReadedParams(event.article));
      print('marks as readed - $failureOrArticleReaded');
      yield* _eitherArticlesUpdatedOrNot(failureOrArticleReaded);
    }
  }

  Stream<ArticlesState> _eitherArticlesOrNot(
      Either<Failure, List<Article>> failureOrArticles) async* {
    yield failureOrArticles.fold(
        (failure) =>
            state.copyWith(failure: failure, status: ArticlesStatus.empty),
        (articles) =>
            state.copyWith(articles: articles, status: ArticlesStatus.success));
  }

  Stream<ArticlesState> _eitherArticlesUpdatedOrNot(
      Either<Failure, Article> failureOrArticleUpdated) async* {
    yield failureOrArticleUpdated.fold(
        (failure) =>
            state.copyWith(failure: failure, status: ArticlesStatus.empty),
        (updatedArticle) => state.copyWith(
            articles: state.articles.map((article) {
              if (article.id == updatedArticle.id) {
                return updatedArticle;
              }
              return article;
            }).toList(),
            status: ArticlesStatus.success));

    Future.delayed(const Duration(seconds: 1),
        () => articlesData.updateSharedPrefs(state.articles));
  }

  Stream<ArticlesState> _eitherArticleAddedRemovedOrNot(
      Either<Failure, Article> failureOrArticleUpdated, bool isRemove) async* {
    yield failureOrArticleUpdated.fold(
        (failure) =>
            state.copyWith(failure: failure, status: ArticlesStatus.empty),
        (updatedArticle) {
      final updatedList = List.of(state.articles);
      isRemove
          ? updatedList.remove(updatedArticle)
          : updatedList.add(updatedArticle);
      return state.articles.isNotEmpty
          ? state.copyWith(
              articles: updatedList, status: ArticlesStatus.success)
          : state.copyWith(
              articles: [updatedArticle], status: ArticlesStatus.success);
    });
    Future.delayed(const Duration(seconds: 1),
        () => articlesData.updateSharedPrefs(state.articles));
  }
}

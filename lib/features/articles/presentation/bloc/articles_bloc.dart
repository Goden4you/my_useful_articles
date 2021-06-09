import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/config.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/add_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/edit_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/get_all_articles.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_readed.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_unreaded.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/remove_article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetAllArticles getAllArticles;
  final AddArticle addArticle;
  final RemoveArticle removeArticle;
  final MarkArticleAsReaded markArticleAsReaded;
  final MarkArticleAsUnreaded markArticleAsUnreaded;
  final EditArticle editArticle;

  ArticlesBloc(
      {@required this.getAllArticles,
      @required this.addArticle,
      @required this.removeArticle,
      @required this.markArticleAsReaded,
      @required this.markArticleAsUnreaded,
      @required this.editArticle})
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
      final failureOrArticleAdded = await addArticle(AddArticleParams(
          id: state.articles.length,
          title: event.title,
          body: event.body,
          image: event.image,
          folder: event.folder,
          status: event.status));
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
      yield* _eitherArticlesUpdatedOrNot(failureOrArticleReaded);
    }

    if (event is MarkArticleAsUnReadedRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticleUnreaded = await markArticleAsUnreaded(
          MarkArticleAsUnreadedParams(event.article));
      yield* _eitherArticlesUpdatedOrNot(failureOrArticleUnreaded);
    }

    if (event is EditArticleRequested) {
      yield state.copyWith(status: ArticlesStatus.loading);
      final failureOrArticleEdit = await editArticle(EditArticleParams(
          id: event.id,
          title: event.title,
          body: event.body,
          image: event.image,
          folder: event.folder,
          status: event.status));
      yield* _eitherArticlesUpdatedOrNot(failureOrArticleEdit);
    }
  }

  Stream<ArticlesState> _eitherArticlesOrNot(
      Either<Failure, List<Article>> failureOrArticles) async* {
    yield failureOrArticles.fold(
        (failure) =>
            state.copyWith(failure: failure, status: ArticlesStatus.empty),
        (articles) {
      List<String> folders = [];
      for (var article in articles)
        if (!folders.contains(article.folder)) {
          folders.add(article.folder);
        }

      print('folders -- $folders');
      print('state folders -- ${state.existingFolders}');
      return state.copyWith(
          articles: articles,
          existingFolders: folders,
          status: ArticlesStatus.success);
    });
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
      final updatedFolders = List.of(state.existingFolders);
      var countOfArticlesWithSameFolder = 0;
      for (var article in state.articles)
        if (state.existingFolders.contains(article.folder) &&
            article.folder == updatedArticle.folder)
          countOfArticlesWithSameFolder++;
      if (isRemove) {
        updatedList.remove(updatedArticle);
        if (countOfArticlesWithSameFolder == 1)
          updatedFolders.remove(updatedArticle.folder);
      } else {
        updatedList.add(updatedArticle);
        print('folderCount -- $countOfArticlesWithSameFolder');
        if (countOfArticlesWithSameFolder == 0) {
          print('folder added');
          updatedFolders.add(updatedArticle.folder);
        }
      }
      print('updatedFolders -- $updatedFolders');
      return state.articles.isNotEmpty
          ? state.copyWith(
              articles: updatedList,
              existingFolders: updatedFolders,
              status: ArticlesStatus.success)
          : state.copyWith(
              articles: [updatedArticle],
              existingFolders: [updatedArticle.folder],
              status: ArticlesStatus.success);
    });
    Future.delayed(const Duration(seconds: 1),
        () => articlesData.updateSharedPrefs(state.articles));
  }
}

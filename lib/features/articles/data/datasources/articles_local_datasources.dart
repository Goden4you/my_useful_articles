import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selfDevelopment/features/articles/data/model/article_model.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

const All_ARTICLES = 'All_ARTICLES';

abstract class ArticlesLocalDataSources {
  Future<List<ArticleModel>> getAllArticles();
  Future<ArticleModel> addArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status});
  Future<ArticleModel> removeArticle(Article article);
  Future<ArticleModel> markArticleAsReaded(Article article);
  Future<ArticleModel> markArticleAsUnreaded(Article article);
  Future<ArticleModel> editArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status});

  Future<void> updateSharedPrefs(List<Article> articles);
}

class ArticlesLocalDataSourcesImpl implements ArticlesLocalDataSources {
  SharedPreferences sharedPreferences;
  List<Article> articles = List<Article>();

  ArticlesLocalDataSourcesImpl({@required this.sharedPreferences});

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    final jsonArticle = sharedPreferences.getStringList(All_ARTICLES);
    if (jsonArticle != null) {
      articles = jsonArticle
          .map((article) => ArticleModel.fromJson(jsonDecode(article)))
          .toList();
      return articles;
    } else
      return [];
  }

  @override
  Future<ArticleModel> addArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status}) async {
    ArticleModel article = ArticleModel(
        id: id,
        title: title,
        body: body,
        image: image,
        folder: folder,
        status: status);
    return article;
  }

  @override
  Future<ArticleModel> removeArticle(Article article) async {
    return article;
  }

  @override
  Future<void> updateSharedPrefs(List<Article> newArticles) async {
    List<String> updatedArticles =
        newArticles.map((article) => json.encode(article.toJson())).toList();
    articles = newArticles;
    sharedPreferences.setStringList(All_ARTICLES, updatedArticles);
  }

  @override
  Future<ArticleModel> markArticleAsReaded(
    Article article,
  ) async {
    final newArticleToReplace = ArticleModel(
        id: article.id,
        title: article.title,
        body: article.body,
        image: article.image,
        folder: article.folder,
        status: ArticleStatus.Readed);

    return newArticleToReplace;
  }

  @override
  Future<ArticleModel> markArticleAsUnreaded(
    Article article,
  ) async {
    final newArticleToReplace = ArticleModel(
        id: article.id,
        title: article.title,
        body: article.body,
        image: article.image,
        folder: article.folder,
        status: ArticleStatus.Unreaded);

    return newArticleToReplace;
  }

  @override
  Future<ArticleModel> editArticle(
      {int id,
      String title,
      String body,
      String image,
      String folder,
      ArticleStatus status}) async {
    final newArticleToReplace = ArticleModel(
        id: id,
        title: title,
        body: body,
        image: image,
        folder: folder,
        status: status);

    return newArticleToReplace;
  }
}

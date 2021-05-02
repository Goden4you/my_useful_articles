import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selfDevelopment/features/articles/data/model/article_model.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

const All_ARTICLES = 'All_ARTICLES';

abstract class ArticlesLocalDataSources {
  Future<List<ArticleModel>> getAllArticles();
  Future<ArticleModel> addArticle(String title, String body);
  Future<ArticleModel> removeArticle(Article article);
  Future<ArticleModel> markArticleAsReaded(Article article);

  Future<void> updateSharedPrefs(List<Article> articles);
  Future<void> editArticleTitle(String title, int id);
  Future<void> editArticleBody(String title, int id);
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
  Future<ArticleModel> addArticle(String title, String body) async {
    print('articles length -- ${articles.length}');
    ArticleModel article = ArticleModel(
        id: articles.length,
        title: title,
        body: body,
        status: ArticleStatus.Unreaded);
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
        status: ArticleStatus.Readed);
    print('newArticle -- $newArticleToReplace');

    return newArticleToReplace;
  }

  @override
  Future<void> editArticleTitle(String title, int id) async {}

  @override
  Future<void> editArticleBody(String body, int id) async {}
}

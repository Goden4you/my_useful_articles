import 'package:get_it/get_it.dart';
import 'package:selfDevelopment/features/articles/data/datasources/articles_local_datasources.dart';
import 'package:selfDevelopment/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/add_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/edit_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/get_all_articles.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_readed.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_unreaded.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/remove_article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/search/data/datasources/search_local_datasources.dart';
import 'package:selfDevelopment/features/search/data/repositories/search_repository.dart';
import 'package:selfDevelopment/features/search/domain/repositories/search_repository.dart';
import 'package:selfDevelopment/features/search/domain/usecases/add_search_input.dart';
import 'package:selfDevelopment/features/search/domain/usecases/get_all_searches.dart';
import 'package:selfDevelopment/features/search/domain/usecases/update_current_input.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator..registerLazySingleton(() => sharedPreferences);

  await _initArticlesFeature();
  await _initSearchFeature();
}

Future<void> _initArticlesFeature() async {
  serviceLocator
    // Bloc
    ..registerFactory(() => ArticlesBloc(
        getAllArticles: serviceLocator(),
        addArticle: serviceLocator(),
        removeArticle: serviceLocator(),
        markArticleAsReaded: serviceLocator(),
        markArticleAsUnreaded: serviceLocator(),
        editArticle: serviceLocator()))
    // Usecase
    ..registerLazySingleton(() => GetAllArticles(serviceLocator()))
    ..registerLazySingleton(() => AddArticle(serviceLocator()))
    ..registerLazySingleton(() => RemoveArticle(serviceLocator()))
    ..registerLazySingleton(() => MarkArticleAsReaded(serviceLocator()))
    ..registerLazySingleton(() => MarkArticleAsUnreaded(serviceLocator()))
    ..registerLazySingleton(() => EditArticle(serviceLocator()))
    // Repository
    ..registerLazySingleton<ArticlesRepository>(() => ArticlesRepositoryImpl(
          articlesLocalDataSources: serviceLocator(),
        ))
    // Data source
    ..registerLazySingleton<ArticlesLocalDataSources>(() =>
        ArticlesLocalDataSourcesImpl(sharedPreferences: serviceLocator()));
}

Future<void> _initSearchFeature() async {
  serviceLocator
    // Bloc
    ..registerFactory(() => SearchBloc(
          getAllSearches: serviceLocator(),
          addSearchInput: serviceLocator(),
          updateCurrentInput: serviceLocator(),
        ))

    // Usecase
    ..registerLazySingleton(() => GetAllSearches(serviceLocator()))
    ..registerLazySingleton(() => AddSearchInput(serviceLocator()))
    ..registerLazySingleton(() => UpdateCurrentInput(serviceLocator()))

    // Repository
    ..registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
          searchesLocalDataSources: serviceLocator(),
        ))

    // Data source
    ..registerLazySingleton<SearchesLocalDataSources>(() =>
        SearchesLocalDataSourcesImpl(sharedPreferences: serviceLocator()));
}

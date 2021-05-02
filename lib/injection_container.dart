import 'package:get_it/get_it.dart';
import 'package:selfDevelopment/features/articles/data/datasources/articles_local_datasources.dart';
import 'package:selfDevelopment/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/add_article.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/get_all_articles.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/mark_article_as_readed.dart';
import 'package:selfDevelopment/features/articles/domain/usecases/remove_article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator..registerLazySingleton(() => sharedPreferences);

  await _initArticlesFeature();
}

Future<void> _initArticlesFeature() async {
  serviceLocator
    // Bloc
    ..registerFactory(() => ArticlesBloc(
        getAllArticles: serviceLocator(),
        addArticle: serviceLocator(),
        removeArticle: serviceLocator(),
        markArticleAsReaded: serviceLocator()))
    // Usecase
    ..registerLazySingleton(() => GetAllArticles(serviceLocator()))
    ..registerLazySingleton(() => AddArticle(serviceLocator()))
    ..registerLazySingleton(() => RemoveArticle(serviceLocator()))
    ..registerLazySingleton(() => MarkArticleAsReaded(serviceLocator()))
    // Repository
    ..registerLazySingleton<ArticlesRepository>(() => ArticlesRepositoryImpl(
          articlesLocalDataSources: serviceLocator(),
        ))
    // Data source
    ..registerLazySingleton<ArticlesLocalDataSources>(() =>
        ArticlesLocalDataSourcesImpl(sharedPreferences: serviceLocator()));
}

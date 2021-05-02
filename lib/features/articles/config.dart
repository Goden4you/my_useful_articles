import 'package:selfDevelopment/features/articles/data/datasources/articles_local_datasources.dart';
import 'package:selfDevelopment/injection_container.dart';

ArticlesLocalDataSourcesImpl articlesData =
    ArticlesLocalDataSourcesImpl(sharedPreferences: serviceLocator());

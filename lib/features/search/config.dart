import 'package:selfDevelopment/features/search/data/datasources/search_local_datasources.dart';
import 'package:selfDevelopment/injection_container.dart';

SearchesLocalDataSourcesImpl searchData =
    SearchesLocalDataSourcesImpl(sharedPreferences: serviceLocator());

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:selfDevelopment/core/presentation/layouts/main_layout.dart';
import 'package:selfDevelopment/features/articles/data/datasources/articles_local_datasources.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/add_article_page.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/article_page.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/articles_page.dart';
import 'package:selfDevelopment/features/settings/domain/entities/custom_theme_data.dart';
import 'package:selfDevelopment/injection_container.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyUsefulApp());
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class MyUsefulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesBloc>(
          create: (_) =>
              serviceLocator<ArticlesBloc>()..add(GetAllArticlesRequested()),
        )
      ],
      child: AppView(),
    );
  }
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  ArticlesLocalDataSourcesImpl articles =
      ArticlesLocalDataSourcesImpl(sharedPreferences: serviceLocator());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Useful Articles',
      navigatorKey: _navigatorKey,
      theme: CustomThemeData.lightTheme,
      themeMode: ThemeMode.light,
      routes: {
        ArticlesPage.routeName: (BuildContext context) => MainLayout(
              child: ArticlesPage(),
            ),
        ArticlePage.routeName: (BuildContext context) => ArticlePage(),
        AddArticlePage.routeName: (BuildContext context) => AddArticlePage(),
      },
      home: LoaderOverlay(
          useDefaultLoading: true,
          overlayColor: Colors.black,
          child: MainLayout(
            child: ArticlesPage(),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    articles.getAllArticles();
  }
}

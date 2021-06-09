import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';
import 'package:selfDevelopment/features/articles/presentation/widgets/readed_articles_list.dart';
import 'package:selfDevelopment/features/articles/presentation/widgets/unreaded_articles_list.dart';

class ArticlesPage extends StatefulWidget {
  static const routeName = '/articles';

  ArticlesPage({Key key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticlesBloc, ArticlesState>(
      listener: (context, state) {
        if (state.status == ArticlesStatus.success ||
            state.status == ArticlesStatus.failure) {
          context.hideLoaderOverlay();
          _refreshController.refreshCompleted();
        }
      },
      builder: (BuildContext context, state) {
        if (state.status != ArticlesStatus.success) {
          return Container(
              color: Colors.white, child: Text('nothing was loaded'));
        } else {
          final readedArticles = state.articles
              ?.where((article) => article.status == ArticleStatus.Readed)
              ?.toList();

          final unreadedArticles = state.articles
              ?.where((article) => article.status == ArticleStatus.Unreaded)
              ?.toList();

          final unreadedArticlesWithImages = unreadedArticles
              ?.where((article) => article.image != null)
              ?.toList();

          final unreadedArticlesWithoutImages = unreadedArticles
              ?.where((article) => article.image == null)
              ?.toList();

          return Container(
            color: Theme.of(context).cardColor,
            child: SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  BlocProvider.of<ArticlesBloc>(context)
                    ..add(GetAllArticlesRequested());
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (unreadedArticles.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 8, left: 16, right: 16),
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).backgroundColor,
                          child: Text(
                            "Actual",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        UnreadedArticlesList(
                          unreadedArticles: unreadedArticles,
                          unreadedArticlesWithImages:
                              unreadedArticlesWithImages,
                          unreadedArticlesWithoutImages:
                              unreadedArticlesWithoutImages,
                        )
                      ],
                      if (readedArticles.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 8, left: 16, right: 16),
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).backgroundColor,
                          child: Text(
                            "Readed",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        ReadedArticlesList(
                          readedArticles: readedArticles,
                          existingFolders: state.existingFolders,
                        )
                      ]
                    ],
                  ),
                )),
          );
        }
      },
    );
  }
}

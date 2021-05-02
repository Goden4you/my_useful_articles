import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/article_page.dart';

class ReadedArticleItem extends StatelessWidget {
  final Article article;
  ReadedArticleItem({@required this.article});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/article',
          arguments:
              ArticlePageArguments(title: article.title, body: article.body)),
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).backgroundColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                article.body.length > 30
                    ? '${article.body.substring(0, 30)}...'
                    : article.body,
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          )),
    );
  }
}

class UnreadedArticleItem extends StatelessWidget {
  final Article article;
  UnreadedArticleItem({@required this.article});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/article',
          arguments:
              ArticlePageArguments(title: article.title, body: article.body)),
      onLongPress: () => BlocProvider.of<ArticlesBloc>(context)
        ..add(MarkArticleAsReadedRequested(article)),
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).backgroundColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(article.title, style: Theme.of(context).textTheme.headline3),
              Text(
                  article.body.length > 30
                      ? '${article.body.substring(0, 30)}...'
                      : article.body,
                  style: Theme.of(context).textTheme.subtitle1)
            ],
          )),
    );
  }
}

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
        if (state.status == ArticlesStatus.empty ||
            state.status == ArticlesStatus.failure) {
          return Container(
              color: Colors.white, child: Text('nothing was loaded'));
        } else {
          final readedArticles = state.articles
              .where((article) => article.status == ArticleStatus.Readed)
              .toList();

          final unreadedArticles = state.articles
              .where((article) => article.status == ArticleStatus.Unreaded)
              .toList();

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
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: unreadedArticles.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = unreadedArticles[index];
                              return Dismissible(
                                key: Key(item.toString()),
                                onDismissed: (direction) {
                                  BlocProvider.of<ArticlesBloc>(context)
                                    ..add(RemoveArticleRequested(item));
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      'Article deleted',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: Colors.white),
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                },
                                child: UnreadedArticleItem(
                                    article: unreadedArticles[index]),
                              );
                            })
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: SvgPicture.asset(
                                  'assets/svg/flutterLogo.svg'),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: readedArticles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = readedArticles[index];
                                    return Dismissible(
                                      key: Key(item.toString()),
                                      onDismissed: (direction) {
                                        BlocProvider.of<ArticlesBloc>(context)
                                          ..add(RemoveArticleRequested(item));
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Article deleted',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(color: Colors.white),
                                          ),
                                          duration: const Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      },
                                      child: ReadedArticleItem(
                                          article: readedArticles[index]),
                                    );
                                  }),
                            )
                          ],
                        ),
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

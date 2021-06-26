import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/core/presentation/widgets/snackbars.dart';
import 'package:selfDevelopment/core/utils/special_character_handler.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/article_page.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_bloc.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_state.dart';

import '../../../../core/utils/string_capitalize.dart';

const blueColorForSnackBar = const Color(0xff68A0F4);

class ReadedArticleItem extends StatelessWidget {
  final Article article;
  final List<List<String>> searchFormattedArr;
  ReadedArticleItem({@required this.article, this.searchFormattedArr});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/article',
          arguments: ArticlePageArguments(article: article)),
      child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).backgroundColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchFormattedArr == null
                  ? Text(article.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(height: 1.4))
                  : RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(height: 1.4),
                          children: [
                            ...searchFormattedArr.map((textArr) {
                              if (textArr.first == 'normal')
                                return TextSpan(text: textArr.last);
                              return TextSpan(
                                  text: textArr.last,
                                  style: TextStyle(
                                      backgroundColor: Colors.yellow));
                            })
                          ]),
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

class ReadedArticlesList extends StatefulWidget {
  final List<Article> readedArticles;
  final List<String> existingFolders;
  // final GlobalKey<S>
  ReadedArticlesList(
      {Key key, @required this.readedArticles, @required this.existingFolders})
      : super(key: key);

  @override
  _ReadedArticlesListState createState() => _ReadedArticlesListState();
}

class _ReadedArticlesListState extends State<ReadedArticlesList> {
  List<List<String>> searchArr = [];
  List<Article> searchArticles = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          searchArticles = widget.readedArticles
              .where((article) => article.title
                  .toLowerCase()
                  .contains(state.currentInput.toLowerCase()))
              .toList();
        },
        listenWhen: (prevState, state) =>
            prevState.currentInput != state.currentInput,
        builder: (context, state) {
          if (state.currentInput.isNotEmpty && searchArticles.length == 0)
            return Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                'Nothing was founded',
                style: Theme.of(context).textTheme.headline3,
              ),
            );
          else
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.existingFolders?.map((folder) {
                  final _readedArticles = widget.readedArticles
                      .where((article) => state.currentInput.isNotEmpty
                          ? folder == article.folder &&
                              searchArticles.contains(article)
                          : folder == article.folder)
                      .toList();
                  if (_readedArticles.length != 0)
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          width: MediaQuery.of(context).size.width * 0.3,
                          // child: SvgPicture.asset('assets/svg/flutterLogo.svg'),
                          child: Text(
                            folder.capitalize() ?? 'Unknown folder',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _readedArticles.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = _readedArticles[index];
                                searchArr = searchSpecialCharacters(
                                    item.title, state.currentInput, null);
                                return Dismissible(
                                  key: UniqueKey(),
                                  background: Container(
                                    color: Color(0xffDDDDDD),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Icon(
                                            Icons.mark_email_unread_outlined),
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Color(0xffCB2B2B),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.delete_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _readedArticles.remove(item);
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        content: Row(
                                          children: [
                                            CircularCountDownTimer(
                                              duration: 6,
                                              initialDuration: 0,
                                              isReverse: true,
                                              isReverseAnimation: true,
                                              fillColor: Theme.of(context)
                                                  .snackBarTheme
                                                  .backgroundColor,
                                              ringColor: blueColorForSnackBar,
                                              width: 25,
                                              height: 25,
                                              strokeWidth: 2,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: Colors.white),
                                              onComplete: () {
                                                context
                                                    .read<ArticlesBloc>()
                                                    .add(RemoveArticleRequested(
                                                        item));
                                                Scaffold.of(context)
                                                    .removeCurrentSnackBar();
                                              },
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Article deleted',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: Colors.white),
                                            )
                                          ],
                                        ),
                                        action: SnackBarAction(
                                          label: "Undo",
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .removeCurrentSnackBar();
                                            _readedArticles.add(item);
                                            setState(() {});
                                          },
                                        ),
                                        duration: const Duration(
                                            seconds:
                                                10), // tapped more to handle correct removing
                                      ));
                                    } else if (direction ==
                                        DismissDirection.startToEnd)
                                      markAsUnreadSnackBar(context, null, item);
                                  },
                                  child: ReadedArticleItem(
                                    article: item,
                                    searchFormattedArr: searchArr.length > 1 ||
                                            searchArr?.first?.first == 'special'
                                        ? searchArr
                                        : null,
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  else
                    return Container();
                })
              ],
            );
        });
  }
}

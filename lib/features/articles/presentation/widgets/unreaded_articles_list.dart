import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/core/presentation/widgets/snackbars.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/pages/article_page.dart';

const blueColorForSnackBar = const Color(0xff68A0F4);

class UnreadedArticleItem extends StatelessWidget {
  final Article article;
  UnreadedArticleItem({@required this.article});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/article',
          arguments: ArticlePageArguments(article: article)),
      child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
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

class UnreadedArticlesList extends StatefulWidget {
  final List<Article> unreadedArticles;
  final List<Article> unreadedArticlesWithImages;
  final List<Article> unreadedArticlesWithoutImages;

  const UnreadedArticlesList(
      {Key key,
      @required this.unreadedArticles,
      @required this.unreadedArticlesWithImages,
      @required this.unreadedArticlesWithoutImages})
      : super(key: key);

  @override
  _UnreadedArticlesListState createState() => _UnreadedArticlesListState();
}

class _UnreadedArticlesListState extends State<UnreadedArticlesList> {
  @override
  Widget build(BuildContext context) {
    return widget.unreadedArticlesWithImages.length < 3
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.unreadedArticles.length,
            itemBuilder: (BuildContext context, int index) {
              final item = widget.unreadedArticles[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Color(0xffDDDDDD),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.mark_email_read_outlined),
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
                  widget.unreadedArticles.remove(item);
                  setState(() {});
                  if (direction == DismissDirection.endToStart) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      content: Row(
                        children: [
                          CircularCountDownTimer(
                            duration: 6,
                            initialDuration: 0,
                            isReverse: true,
                            isReverseAnimation: true,
                            fillColor:
                                Theme.of(context).snackBarTheme.backgroundColor,
                            ringColor: blueColorForSnackBar,
                            width: 25,
                            height: 25,
                            strokeWidth: 2,
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.white),
                            onComplete: () {
                              context
                                  .read<ArticlesBloc>()
                                  .add(RemoveArticleRequested(item));
                              Scaffold.of(context).removeCurrentSnackBar();
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
                                .copyWith(color: Colors.white),
                          )
                        ],
                      ),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          Scaffold.of(context).removeCurrentSnackBar();
                          widget.unreadedArticles.add(item);
                          setState(() {});
                        },
                      ),
                      duration: const Duration(
                          seconds:
                              10), // tapped more to handle correct removing
                    ));
                  } else if (direction == DismissDirection.startToEnd) {
                    markAsReadSnackBar(context, null, item);
                  }
                },
                child: UnreadedArticleItem(article: item),
              );
            })
        : Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(autoPlay: true, height: 300),
                items:
                    widget.unreadedArticlesWithImages.map((articleWithImage) {
                  final index = widget.unreadedArticlesWithImages
                      .indexOf(articleWithImage);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Color(0xffDDDDDD),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Icon(Icons.mark_email_read_outlined),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Color(0xffCB2B2B),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Icon(
                            Icons.delete_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    direction: DismissDirection.vertical,
                    onDismissed: (direction) {
                      widget.unreadedArticlesWithImages.add(articleWithImage);
                      widget.unreadedArticles.remove(articleWithImage);
                      setState(() {});
                      if (direction == DismissDirection.up) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
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
                                    .copyWith(color: Colors.white),
                                onComplete: () {
                                  context.read<ArticlesBloc>().add(
                                      RemoveArticleRequested(articleWithImage));
                                  Scaffold.of(context).removeCurrentSnackBar();
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
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          ),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              Scaffold.of(context).removeCurrentSnackBar();
                              widget.unreadedArticlesWithImages
                                  .add(articleWithImage);
                              widget.unreadedArticles.add(articleWithImage);
                              setState(() {});
                            },
                          ),
                          duration: const Duration(
                              seconds:
                                  10), // tapped more to handle correct removing
                        ));
                      } else if (direction == DismissDirection.down) {
                        markAsReadSnackBar(context, null, articleWithImage);
                      }
                    },
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/article',
                          arguments: ArticlePageArguments(
                            article: widget.unreadedArticlesWithImages[index],
                          )),
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.file(File(articleWithImage.image),
                                    fit: BoxFit.cover, width: 1000.0),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      '${widget.unreadedArticlesWithImages[index].title}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  );
                }).toList(),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.unreadedArticlesWithoutImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.unreadedArticlesWithoutImages[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Color(0xffDDDDDD),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(Icons.mark_email_read),
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
                        widget.unreadedArticlesWithoutImages.remove(item);
                        setState(() {});
                        if (direction == DismissDirection.endToStart) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
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
                                      .copyWith(color: Colors.white),
                                  onComplete: () {
                                    context
                                        .read<ArticlesBloc>()
                                        .add(RemoveArticleRequested(item));
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
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                Scaffold.of(context).removeCurrentSnackBar();
                                widget.unreadedArticles.add(item);
                                setState(() {});
                              },
                            ),
                            duration: const Duration(
                                seconds:
                                    10), // tapped more to handle correct removing
                          ));
                        } else if (direction == DismissDirection.startToEnd)
                          markAsReadSnackBar(context, null, item);
                      },
                      child: UnreadedArticleItem(article: item),
                    );
                  })
            ],
          );
  }
}

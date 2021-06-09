import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';

markAsReadSnackBar(
    BuildContext context, GlobalKey<ScaffoldState> globalKey, Article item) {
  BlocProvider.of<ArticlesBloc>(context)
    ..add(MarkArticleAsReadedRequested(item));
  final SnackBar snackBar = SnackBar(
    content: Text(
      'Article marked as read',
      style:
          Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
    ),
    duration: const Duration(seconds: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    behavior: SnackBarBehavior.floating,
  );

  globalKey != null
      ? globalKey.currentState.showSnackBar(snackBar)
      : Scaffold.of(context).showSnackBar(snackBar);
}

markAsUnreadSnackBar(
    BuildContext context, GlobalKey<ScaffoldState> globalKey, Article item) {
  BlocProvider.of<ArticlesBloc>(context)
    ..add(MarkArticleAsUnReadedRequested(item));
  final SnackBar snackBar = SnackBar(
    content: Text(
      'Article marked as unread',
      style:
          Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
    ),
    duration: const Duration(seconds: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    behavior: SnackBarBehavior.floating,
  );

  globalKey != null
      ? globalKey.currentState.showSnackBar(snackBar)
      : Scaffold.of(context).showSnackBar(snackBar);
}

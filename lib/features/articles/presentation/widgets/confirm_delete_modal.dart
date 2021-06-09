import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';

Widget confirmDeleteModal(BuildContext context, Article article) {
  return AlertDialog(
    title: Text('Delete'),
    content: Text('Are you sure?'),
    actions: [
      FlatButton(
        child: Text("Cancel"),
        onPressed: () => Navigator.of(context).pop(),
      ),
      SizedBox(
        width: 16,
      ),
      FlatButton(
        child: Text("I'm sure"),
        onPressed: () {
          BlocProvider.of<ArticlesBloc>(context)
            ..add(RemoveArticleRequested(article));
          Navigator.of(context).pop(); // first for closing modal
          Navigator.of(context).pop(); // second to move on main page
        },
      )
    ],
  );
}

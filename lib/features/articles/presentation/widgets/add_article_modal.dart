import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';

class AddArticleModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(right: 16),
      icon: Icon(Icons.add),
      onPressed: () {
        // BlocProvider.of<ArticlesBloc>(context)
        // ..add(AddArticleRequested('Title', 'Some Body Text'));
      },
    );
  }
}

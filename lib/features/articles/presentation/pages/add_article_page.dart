import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';

class AddArticlePage extends StatefulWidget {
  static const routeName = '/addArticle';
  @override
  _AddArticlePageState createState() {
    return _AddArticlePageState();
  }
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Article'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(8),
        child: _renderLoginForm(context),
      ),
    );
  }

  _renderLoginForm(BuildContext context) {
    final node = FocusScope.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('Here you will add image'),
          ),
          TextFormField(
            controller: _titleController,
            onEditingComplete: () => node.nextFocus(),
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: _bodyController,
            onEditingComplete: () => node.unfocus(),
            decoration: InputDecoration(labelText: 'Some Body Text'),
          ),
          ElevatedButton(
            onPressed: () {
              node.unfocus();
              BlocProvider.of<ArticlesBloc>(context)
                ..add(AddArticleRequested(
                    _titleController.text, _bodyController.text));
              Navigator.pop(context);
            },
            child: Center(child: Text('Submit')),
          )
        ],
      ),
    );
  }
}

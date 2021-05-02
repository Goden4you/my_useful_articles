import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/domain/entities/route_arguments.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

class ArticlePage extends StatefulWidget {
  static const routeName = '/article';
  final Article article;
  final String folderName;

  ArticlePage({this.article, this.folderName = 'Flutter'});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class ArticlePageArguments extends RouteArguments {
  final String title;
  final String body;
  final String folderName;

  ArticlePageArguments({this.title, this.body, this.folderName = 'Flutter'});
  @override
  // TODO: implement props
  List<Object> get props => [
        title,
        body,
        folderName,
      ];
}

class _ArticlePageState extends State<ArticlePage> {
  bool canEdit = false;
  String newTitle = '';
  @override
  Widget build(BuildContext context) {
    final ArticlePageArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.folderName),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: [
          canEdit
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      canEdit = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      canEdit = true;
                    });
                  },
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              GestureDetector(
                onLongPress: () => canEdit ? openPhotoManager() : null,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(child: Text('Here will be image')),
                ),
              ),
              canEdit
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        decoration: InputDecoration(hintText: args.title),
                        onChanged: (String value) {
                          setState(() {
                            newTitle = value;
                          });
                        },
                        onEditingComplete: () {},
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          args.title,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
              Text(
                args.body,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openPhotoManager() {
    // TODO: add logic
    print('photo manager pressed');
  }
}

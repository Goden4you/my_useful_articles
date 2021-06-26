import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/core/domain/entities/route_arguments.dart';
import 'package:selfDevelopment/core/presentation/widgets/snackbars.dart';
import 'package:selfDevelopment/core/utils/take_image.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/widgets/confirm_delete_modal.dart';

import '../../../../core/utils/string_capitalize.dart';

const availibleOptions = {
  'Edit': Icon(Icons.edit_outlined),
  'Delete': Icon(Icons.delete_outlined),
  'Mark as read': Icon(Icons.mark_email_read_outlined),
  'Mark as unread': Icon(Icons.mark_email_unread_outlined),
};

class ArticlePage extends StatefulWidget {
  static const routeName = '/article';

  const ArticlePage();

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class ArticlePageArguments extends RouteArguments {
  final Article article;

  ArticlePageArguments({this.article});
  @override
  // TODO: implement props
  List<Object> get props => [
        article,
      ];
}

class _ArticlePageState extends State<ArticlePage> {
  bool canEdit = false;
  bool isOptionsVisible = false;
  final globalKey = GlobalKey<ScaffoldState>();

  String newTitle;
  String newBody;
  String newImage;
  @override
  Widget build(BuildContext context) {
    final ArticlePageArguments args = ModalRoute.of(context).settings.arguments;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => isOptionsVisible
              ? setState(() {
                  isOptionsVisible = false;
                })
              : null,
          child: Scaffold(
            key: globalKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              title: canEdit ? null : Text(args.article.folder.capitalize()),
              leading: canEdit
                  ? Container()
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
              backgroundColor: Theme.of(context).primaryColorDark,
              flexibleSpace: canEdit
                  ? Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                canEdit = false;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              BlocProvider.of<ArticlesBloc>(context)
                                ..add(EditArticleRequested(
                                    id: args.article.id,
                                    title: newTitle ?? args.article.title,
                                    body: newBody ?? args.article.body,
                                    image: newImage ?? args.article.image,
                                    folder: args.article.folder,
                                    status: args.article.status));
                              setState(() {
                                canEdit = false;
                              });
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
              actions: [
                if (!canEdit) ...[
                  IconButton(
                    icon: Icon(Icons.more_vert_outlined),
                    onPressed: () {
                      setState(() {
                        isOptionsVisible = !isOptionsVisible;
                      });
                    },
                  ),
                ]
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => canEdit
                          ? takeImageFromGallery()
                          : setState(() {
                              isOptionsVisible = false;
                            }),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: double.infinity,
                            height: args.article.image != null ||
                                    newImage != null ||
                                    canEdit
                                ? 300
                                : 0,
                            color: Colors.transparent,
                            child:
                                args.article.image != null || newImage != null
                                    ? Image.file(
                                        File(newImage ?? args.article.image),
                                        fit: BoxFit.fill,
                                      )
                                    : canEdit
                                        ? Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 50,
                                          )
                                        : Container(),
                          )),
                    ),
                    canEdit
                        ? Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: args.article.title,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(width: 1))),
                              onChanged: (String value) {
                                this.newTitle = value;
                              },
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                bottom: 16,
                                top: args.article.image != null ||
                                        newImage != null
                                    ? 16
                                    : 0),
                            child: Center(
                              child: Text(
                                newTitle ?? args.article.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                    canEdit
                        ? Container(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: args.article.body,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(width: 1))),
                              onChanged: (String value) {
                                this.newBody = value;
                              },
                            ),
                          )
                        : Container(
                            child: Text(
                              newBody ??
                                  args.article
                                      .body, // TODO: replace by FormattedText
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Visibility(
            child: Stack(
              children: [
                Positioned(
                  top: 55,
                  right: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 165,
                            child: FlatButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    canEdit = true;
                                    isOptionsVisible = false;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child:
                                          availibleOptions.values.elementAt(0),
                                    ),
                                    Text(availibleOptions.keys.elementAt(0))
                                  ],
                                )),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 165,
                              child: FlatButton(
                                  color: Colors.white,
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => confirmDeleteModal(
                                          context, args.article)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: availibleOptions.values
                                            .elementAt(1),
                                      ),
                                      Text(availibleOptions.keys.elementAt(1))
                                    ],
                                  ))),
                          args.article.status == ArticleStatus.Readed
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  width: 165,
                                  child: FlatButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        markAsUnreadSnackBar(
                                            context, globalKey, args.article);
                                        setState(() {
                                          isOptionsVisible = false;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: availibleOptions.values
                                                .elementAt(3),
                                          ),
                                          Text(availibleOptions.keys
                                              .elementAt(3))
                                        ],
                                      )))
                              : Container(
                                  alignment: Alignment.centerLeft,
                                  width: 165,
                                  child: FlatButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        markAsReadSnackBar(
                                            context, globalKey, args.article);
                                        setState(() {
                                          isOptionsVisible = false;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: availibleOptions.values
                                                .elementAt(2),
                                          ),
                                          Text(availibleOptions.keys
                                              .elementAt(2))
                                        ],
                                      ))),
                        ]),
                  ),
                )
              ],
            ),
            visible: isOptionsVisible,
          ),
        )
      ],
    );
  }
}

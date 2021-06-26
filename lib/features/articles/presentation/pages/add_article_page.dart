import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/core/utils/take_image.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';
import 'package:selfDevelopment/features/articles/presentation/widgets/folder_form_field.dart';

const ANIMATION_BEGIN = 500.0;
const ANIMATION_END = 0.0;

const dropDownStatuses = ['Readed', 'Unreaded'];

class AddArticlePage extends StatefulWidget {
  static const routeName = '/addArticle';
  @override
  _AddArticlePageState createState() {
    return _AddArticlePageState();
  }
}

class _AddArticlePageState extends State<AddArticlePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _image;
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _bodyFocusNode = FocusNode();
  String selectedStatus = 'Unreaded';
  String selectedFolder = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    // final bottom = MediaQuery.of(context).viewInsets.bottom;
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('Add New Article'),
                backgroundColor: Theme.of(context).primaryColorDark,
              ),
              body: BlocBuilder<ArticlesBloc, ArticlesState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      // height: isKeyboardVisible ? 320 + bottom : 700,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _image != null
                                ? Container(
                                    width: double.infinity,
                                    height: 300,
                                    child: Image.file(
                                      File(_image),
                                      fit: BoxFit.fill,
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1)),
                                    height: 300,
                                    child: Center(
                                      child: IconButton(
                                          icon:
                                              Icon(Icons.add_a_photo_outlined),
                                          iconSize: 50,
                                          onPressed: _takeImage),
                                    ),
                                  ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          32,
                                      child: FolderFormField(
                                        notifyNode: () => _notifyNode(node),
                                        setFolderValue: _setFolderValue,
                                        scrollController: _scrollController,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          32,
                                      child: DropdownButtonFormField(
                                        value: selectedStatus,
                                        items: dropDownStatuses
                                            .map((label) => DropdownMenuItem(
                                                  child: Text(label),
                                                  value: label,
                                                ))
                                            .toList(),
                                        onSaved: (value) {
                                          setState(() {
                                            selectedStatus = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                TextFormField(
                                  controller: _titleController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  focusNode: _titleFocusNode,
                                  onEditingComplete: () => node.nextFocus(),
                                  decoration:
                                      InputDecoration(labelText: 'Title'),
                                ),
                                TextFormField(
                                  controller: _bodyController,
                                  focusNode: _bodyFocusNode,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onEditingComplete: () => node.unfocus(),
                                  decoration: InputDecoration(
                                      labelText: selectedStatus == 'Unreaded'
                                          ? 'Description'
                                          : 'Notes'),
                                  maxLines: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 50),
                                  child: FlatButton(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    color: Theme.of(context).primaryColorDark,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    onPressed: () {
                                      node.unfocus();
                                      BlocProvider.of<ArticlesBloc>(context)
                                        ..add(AddArticleRequested(
                                            title: _titleController.text.trim(),
                                            body: _bodyController.text.trim(),
                                            image: _image,
                                            folder: selectedFolder
                                                .trim()
                                                .toLowerCase(),
                                            status: selectedStatus == 'Unreaded'
                                                ? ArticleStatus.Unreaded
                                                : ArticleStatus.Readed));
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                        child: Text(
                                      'Add',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  _notifyNode(FocusScopeNode node) {
    node.nextFocus();
  }

  _setFolderValue(String value) {
    selectedFolder = value;
  }

  _takeImage() async {
    try {
      await takeImageFromGallery().then((image) {
        if (image != null)
          setState(() {
            _image = image;
          });
      });
    } catch (e) {
      print(e);
    }
  }
}

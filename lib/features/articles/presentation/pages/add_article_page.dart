import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_event.dart';

const ANIMATION_BEGIN = 0.0;
const ANIMATION_END = 16.0;

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
  final ImagePicker imagePicker = ImagePicker();

  PickedFile _image;
  AnimationController _animationController;
  Animation _animation;
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _bodyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: ANIMATION_BEGIN, end: ANIMATION_END)
        .animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _bodyFocusNode.addListener(() {
      if (_bodyFocusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Article'),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: new InkWell(
          onTap: () {
            node.requestFocus(FocusNode());
          },
          child: Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _animation.value == ANIMATION_BEGIN
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: _image != null
                              ? Image.file(File(_image.path),
                                  width: 100, height: 70, fit: BoxFit.fill)
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  height: 300,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo_outlined),
                                      iconSize: 50,
                                      onPressed: () {
                                        _imgFromGallery();
                                      },
                                    ),
                                  ),
                                ),
                        )
                      : SizedBox(
                          height: ANIMATION_END,
                        ),
                  TextFormField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: _bodyController,
                    focusNode: _bodyFocusNode,
                    onEditingComplete: () => node.unfocus(),
                    decoration: InputDecoration(labelText: 'Some Body Text'),
                    maxLines: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      node.unfocus();
                      BlocProvider.of<ArticlesBloc>(context)
                        ..add(AddArticleRequested(_titleController.text,
                            _bodyController.text, _image));
                      Navigator.pop(context);
                    },
                    child: Center(child: Text('Submit')),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _imgFromGallery() async {
    PickedFile image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }
}

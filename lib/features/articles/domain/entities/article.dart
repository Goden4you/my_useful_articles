import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ArticleStatus { Readed, Unreaded }

class Article extends Equatable {
  final int id;
  final String title;
  final String body;
  final PickedFile image;
  final ArticleStatus status;

  Article(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.image,
      this.status = ArticleStatus.Unreaded});

  toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "body": this.body,
      "status": this.status,
      "image": this.image
    };
  }

  @override
  List<Object> get props => [id, title, body, image, status];
}

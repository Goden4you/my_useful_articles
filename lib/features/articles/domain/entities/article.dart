import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ArticleStatus { Readed, Unreaded }

class Article extends Equatable {
  final int id;
  final String title;
  final String body;
  final String image;
  final String folder;
  final ArticleStatus status;

  Article(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.image,
      @required this.folder,
      this.status = ArticleStatus.Unreaded});

  toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "body": this.body,
      "image": this.image,
      "folder": this.folder,
      "status": this.status,
    };
  }

  @override
  List<Object> get props => [id, title, body, image, folder, status];
}

import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel extends Article {
  ArticleModel(
      {int id,
      String title,
      String body,
      PickedFile image,
      ArticleStatus status})
      : super(id: id, title: title, body: body, image: image, status: status);

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

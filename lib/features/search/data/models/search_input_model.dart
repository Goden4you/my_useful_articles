import 'package:json_annotation/json_annotation.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';

part 'search_input_model.g.dart';

@JsonSerializable()
class SearchInputModel extends SearchInput {
  SearchInputModel({String input}) : super(input: input);

  factory SearchInputModel.fromJson(Map<String, dynamic> json) =>
      _$SearchInputModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchInputModelToJson(this);
}

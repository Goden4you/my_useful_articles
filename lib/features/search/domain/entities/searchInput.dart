import 'package:equatable/equatable.dart';

class SearchInput extends Equatable {
  final String input;

  SearchInput({this.input});

  @override
  List get props => [input];
}

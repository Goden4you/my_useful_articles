import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_state.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetAllSearchesRequested extends SearchEvent {}

class AddSearchInputRequested extends SearchEvent {
  final String input;

  AddSearchInputRequested({
    this.input,
  });
  @override
  List<Object> get props => [input];
}

class UpdateCurrentInputRequested extends SearchEvent {
  final String input;

  UpdateCurrentInputRequested({
    this.input,
  });
  @override
  List<Object> get props => [input];
}

import 'package:equatable/equatable.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';

enum SearchStatus { empty, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<SearchInput> inputs;
  final Failure failure;
  final String currentInput;

  const SearchState.empty() : this._();

  const SearchState._(
      {this.status = SearchStatus.empty,
      this.inputs = const [],
      this.failure,
      this.currentInput = ''});

  SearchState copyWith(
          {SearchStatus status,
          List<SearchInput> inputs,
          Failure failure,
          String currentInput}) =>
      SearchState._(
          status: status ?? this.status,
          inputs: inputs ?? this.inputs,
          failure: failure ?? this.failure,
          currentInput: currentInput ?? this.currentInput);

  @override
  List<Object> get props => [status, inputs, failure, currentInput];
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/search/config.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';
import 'package:selfDevelopment/features/search/domain/usecases/add_search_input.dart';
import 'package:selfDevelopment/features/search/domain/usecases/get_all_searches.dart';
import 'package:selfDevelopment/features/search/domain/usecases/update_current_input.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_event.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetAllSearches getAllSearches;
  final AddSearchInput addSearchInput;
  final UpdateCurrentInput updateCurrentInput;

  SearchBloc(
      {@required this.getAllSearches,
      @required this.updateCurrentInput,
      @required this.addSearchInput})
      : super(SearchState.empty());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is GetAllSearchesRequested) {
      yield state.copyWith(status: SearchStatus.loading);
      final failureOrInputs = await getAllSearches(NoParams());

      yield* _eitherInputsOrNot(failureOrInputs);
    }

    if (event is AddSearchInputRequested) {
      yield state.copyWith(status: SearchStatus.loading);
      final failureOrInputAdded = await addSearchInput(AddSearchInputParams(
        input: event.input,
      ));
      yield* _eitherSearchInputAddedOrNot(failureOrInputAdded);
    }

    if (event is UpdateCurrentInputRequested) {
      yield state.copyWith(status: SearchStatus.loading);
      final failureOrInputUpdated =
          await updateCurrentInput(UpdateCurrentInputParams(
        input: event.input,
      ));
      print('updated');
      yield* _eitherSearchInputUpdatedOrNot(failureOrInputUpdated);
    }
  }

  Stream<SearchState> _eitherInputsOrNot(
      Either<Failure, List<SearchInput>> failureOrSearches) async* {
    yield failureOrSearches.fold(
        (failure) =>
            state.copyWith(failure: failure, status: SearchStatus.empty),
        (inputs) =>
            state.copyWith(inputs: inputs, status: SearchStatus.success));
  }

  Stream<SearchState> _eitherSearchInputUpdatedOrNot(
      Either<Failure, String> failureOrArticleUpdated) async* {
    yield failureOrArticleUpdated.fold(
        (failure) =>
            state.copyWith(failure: failure, status: SearchStatus.empty),
        (newInput) => state.copyWith(
            currentInput: newInput, status: SearchStatus.success));
  }

  Stream<SearchState> _eitherSearchInputAddedOrNot(
      Either<Failure, SearchInput> failureOrInputAdded) async* {
    yield failureOrInputAdded.fold(
        (failure) =>
            state.copyWith(failure: failure, status: SearchStatus.empty),
        (newInput) {
      final updatedList = List.of(state.inputs);

      if (!state.inputs.contains(newInput)) updatedList.insert(0, newInput);

      return state.inputs.isNotEmpty
          ? state.copyWith(inputs: updatedList, status: SearchStatus.success)
          : state.copyWith(inputs: [newInput], status: SearchStatus.success);
    });
    Future.delayed(const Duration(seconds: 1),
        () => searchData.updateSharedPrefs(state.inputs));
  }
}

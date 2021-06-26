import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selfDevelopment/features/search/data/models/search_input_model.dart';
import 'package:selfDevelopment/features/search/domain/entities/searchInput.dart';
import 'package:shared_preferences/shared_preferences.dart';

const All_SEARCHES = 'All_SEARCHES';

abstract class SearchesLocalDataSources {
  Future<List<SearchInput>> getAllSearches();
  Future<SearchInput> addSearchInput({String input});
  Future<String> updateCurrentInput({String input});

  Future<void> updateSharedPrefs(List<SearchInput> inputs);
}

class SearchesLocalDataSourcesImpl implements SearchesLocalDataSources {
  SharedPreferences sharedPreferences;
  List<SearchInput> inputs = List<SearchInput>();

  SearchesLocalDataSourcesImpl({@required this.sharedPreferences});

  @override
  Future<List<SearchInputModel>> getAllSearches() async {
    final jsonInputs = sharedPreferences.getStringList(All_SEARCHES);
    if (jsonInputs != null) {
      inputs = jsonInputs
          .map((input) => SearchInputModel.fromJson(jsonDecode(input)))
          .toList();
      return inputs;
    } else
      return [];
  }

  @override
  Future<SearchInputModel> addSearchInput({String input}) async {
    SearchInputModel inputModel = SearchInputModel(input: input);
    return inputModel;
  }

  @override
  Future<String> updateCurrentInput({String input}) async {
    return input;
  }

  @override
  Future<void> updateSharedPrefs(List<SearchInput> newInputs) async {
    List<String> updatedSearches =
        newInputs.map((search) => json.encode(search)).toList();
    inputs = newInputs;
    sharedPreferences.setStringList(All_SEARCHES, updatedSearches);
  }
}

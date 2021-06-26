import 'package:selfDevelopment/core/presentation/widgets/formatted_text.dart';

List<List<String>> formattedTextArr = [];

List<List<String>> searchSpecialCharacters(
    // TODO: add dependency on [character]
    String text,
    String search,
    SpecialCharacters character) {
  formattedTextArr.clear();

  character != null ? bodyText(text, character) : searchText(text, search);

  return formattedTextArr.isNotEmpty
      ? formattedTextArr
      : [
          ['normal', text]
        ];
}

void bodyText(String text, SpecialCharacters character) {
  const boldPattern = r'(\*(\w+[ ,.]?)+\*)';

  if (new RegExp(boldPattern).hasMatch(text)) {
    final takedText = new RegExp(boldPattern).stringMatch(text);
    String nextText = '';

    var splittedText = text
        .replaceFirst(takedText, '/#replacing#/')
        .split(new RegExp(r'/#replacing#/'));

    if (splittedText[1] == '  ') splittedText = [splittedText.first];

    if (splittedText.length == 1) {
      formattedTextArr.add(['normal', splittedText[0]]);
    }

    formattedTextArr
        .add(['bold', takedText.substring(1, takedText.length - 1)]);

    if (splittedText.length == 2)
      formattedTextArr.add(['normal', splittedText[1]]);

    nextText = splittedText.length == 1 ? splittedText[0] : splittedText[1];

    return bodyText(nextText, character);
  }
}

void searchText(String text, String search) {
  final lowCaseText = text?.toLowerCase();
  final lowCaseSearch = search?.toLowerCase();

  if (lowCaseText.contains(lowCaseSearch) && search.isNotEmpty) {
    final index = lowCaseText.indexOf(lowCaseSearch);
    if (index > 0) formattedTextArr.add(['normal', text.substring(0, index)]);

    formattedTextArr
        .add(['special', text.substring(index, index + search.length)]);

    return searchText(text.replaceRange(0, search.length + index, ''), search);
  }
  return text.length > 0 ? formattedTextArr.add(['normal', text]) : null;
}

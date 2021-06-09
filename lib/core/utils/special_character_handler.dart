import 'package:selfDevelopment/core/presentation/widgets/formatted_text.dart';

List<List<String>> formattedTextArr = [];

List<List<String>> searchSpecialCharacters(
    // TODO: add dependency on [character]
    String text,
    SpecialCharacters character) {
  const boldPattern = r'(\*(\w+[ ,.]?)+\*)';

  if (new RegExp(boldPattern).hasMatch(text)) {
    final takedText = new RegExp(boldPattern).stringMatch(text);
    String nextText = '';

    var splittedText = text
        .replaceFirst(takedText, '/#replacing#/')
        .split(new RegExp(r'/#replacing#/'));
    print('SPLITTED TEXT VAR 1-- $splittedText');

    print('${RegExp(r'\s+').toString() == splittedText[1]}');
    if (splittedText[1] == '  ') splittedText = [splittedText.first];
    print('SPLITTED TEXT VAR -- $splittedText');

    if (splittedText.length == 1) {
      formattedTextArr.add(['normal', splittedText[0]]);
    }

    formattedTextArr
        .add(['bold', takedText.substring(1, takedText.length - 1)]);

    if (splittedText.length == 2)
      formattedTextArr.add(['normal', splittedText[1]]);

    nextText = splittedText.length == 1 ? splittedText[0] : splittedText[1];

    return searchSpecialCharacters(nextText, character);
  }

  Future.delayed(
      const Duration(milliseconds: 1000), () => formattedTextArr.clear());

  return formattedTextArr.isNotEmpty
      ? formattedTextArr
      : [
          ['normal', text]
        ];
}

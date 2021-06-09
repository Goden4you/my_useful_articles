import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/utils/special_character_handler.dart';

enum SpecialCharacters { bold, normal }

class FormattedText extends StatelessWidget {
  // TODO: need tests
  final String text;
  final SpecialCharacters character;

  const FormattedText({@required this.text, @required this.character, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<List<String>> formattedTextArr =
        searchSpecialCharacters(text, character);
    print('text -- $formattedTextArr');
    return RichText(
      text: TextSpan(children: [
        ...formattedTextArr.map((formattedTextInfo) {
          if (formattedTextInfo[0] == 'bold') // here you can add more "else if"
            return boldText(formattedTextInfo[1]);
          else
            return TextSpan(
                text: formattedTextInfo.last,
                style: TextStyle(color: Colors.black));
        }),
      ], style: TextStyle(fontSize: 18)),
    );
  }
}

TextSpan boldText(String text) {
  return TextSpan(
      text: text,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
}

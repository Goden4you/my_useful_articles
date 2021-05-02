import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selfDevelopment/core/constants/constants.dart';
import 'package:selfDevelopment/features/articles/presentation/widgets/add_article_modal.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({Key key}) : super(key: key);

  String get currentDate => toBeginningOfSentenceCase(
      DateFormat('EEEE, d MMM').format(DateTime.now()));

  @override
  Size get preferredSize => Size.fromHeight(HEADER_HEIGHT);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(currentDate,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 16),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addArticle');
            },
          )
        ],
        flexibleSpace: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 16),
            child: Text(
              'Unreaded articles:',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ));
  }
}
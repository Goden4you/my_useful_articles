import 'package:flutter/material.dart';

class ArticleListDropDown extends StatefulWidget {
  final ListView listView;
  final String title;
  ArticleListDropDown({@required this.listView, @required this.title, Key key})
      : super(key: key);

  @override
  _ArticleListDropDownState createState() => _ArticleListDropDownState();
}

class _ArticleListDropDownState extends State<ArticleListDropDown> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
                height: 34,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(isOpen ? Icons.arrow_downward : Icons.arrow_forward)
                    ],
                  ),
                )),
            Visibility(
              visible: isOpen,
              child: widget.listView,
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_bloc.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_event.dart';
import 'package:selfDevelopment/features/search/presentation/bloc/search_state.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isHistoryVisible = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: offset.dy + size.height,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height),
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state.inputs.map((input) => Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.black))),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      input.input,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                      textAlign: TextAlign.left,
                                    ),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  textEditingController.text = input.input;
                                  context.read<SearchBloc>().add(
                                      UpdateCurrentInputRequested(
                                          input: input.input));

                                  this._overlayEntry.remove();
                                  setState(() {
                                    isHistoryVisible = false;
                                  });
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).backgroundColor,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompositedTransformTarget(
                link: this._layerLink,
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search_outlined),
                        onPressed: () {
                          focusNode.requestFocus();
                        },
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                              labelText: 'Search atricle title'),
                          onChanged: (value) => context
                              .read<SearchBloc>()
                              .add(UpdateCurrentInputRequested(input: value)),
                          onEditingComplete: () {
                            focusNode.unfocus();
                            if (textEditingController.text.isNotEmpty)
                              context.read<SearchBloc>().add(
                                  AddSearchInputRequested(
                                      input: textEditingController.text));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(isHistoryVisible
                            ? Icons.arrow_upward_outlined
                            : Icons.arrow_downward_outlined),
                        onPressed: () {
                          if (state.inputs.isNotEmpty) {
                            if (!isHistoryVisible) {
                              this._overlayEntry = this._createOverlayEntry();
                              Overlay.of(context).insert(this._overlayEntry);
                            } else {
                              this._overlayEntry.remove();
                            }
                            setState(() {
                              isHistoryVisible = !isHistoryVisible;
                            });
                          }
                        },
                      )
                    ],
                  ),
                )),
            // Visibility(
            //   visible: isHistoryVisible,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: state?.inputs?.length,
            //     itemBuilder: (context, index) => Container(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           GestureDetector(
            //             child: Container(
            //               margin: EdgeInsets.only(left: 50),
            //               padding: EdgeInsets.only(left: 8),
            //               child: Text(state.inputs.elementAt(index).input),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

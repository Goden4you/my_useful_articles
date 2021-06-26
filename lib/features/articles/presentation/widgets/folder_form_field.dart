import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_bloc.dart';
import 'package:selfDevelopment/features/articles/presentation/bloc/articles_state.dart';

import '../../../../core/utils/string_capitalize.dart';

class FolderFormField extends StatefulWidget {
  final Function notifyNode;
  final Function setFolderValue;
  final ScrollController scrollController;
  FolderFormField(
      {Key key,
      @required this.notifyNode,
      @required this.setFolderValue,
      @required this.scrollController})
      : super(key: key);

  @override
  _FolderFormFieldState createState() => _FolderFormFieldState();
}

class _FolderFormFieldState extends State<FolderFormField> {
  OverlayEntry _overlayEntry;

  FocusNode _folderFocusNode = FocusNode();
  final TextEditingController _folderController = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _folderController.text = 'Flutter';
    _folderFocusNode.addListener(() {
      if (_folderFocusNode.hasFocus) {
        widget.scrollController.animateTo(0.5,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            child: CompositedTransformFollower(
              link: this._layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: BlocBuilder<ArticlesBloc, ArticlesState>(
                builder: (context, state) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Column(
                    children: [
                      ...state.existingFolders.map((folder) => Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: FlatButton(
                            child: Text(
                              folder.capitalize(),
                              style: Theme.of(context).textTheme.headline3,
                              textAlign: TextAlign.left,
                            ),
                            onPressed: () {
                              _folderController.text = folder.capitalize();
                            },
                          )))
                    ],
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextFormField(
        controller: _folderController,
        focusNode: _folderFocusNode,
        onChanged: widget.setFolderValue,
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: widget.notifyNode,
        decoration: InputDecoration(labelText: 'Folder'),
      ),
    );
  }
}

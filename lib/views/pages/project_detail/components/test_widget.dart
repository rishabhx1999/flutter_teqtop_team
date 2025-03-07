import 'package:flutter/cupertino.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class TestWidget extends StatelessWidget {
  final HtmlEditorController htmlEditorController;
  final Function() htmlEditorOnInit;

  const TestWidget(
      {super.key,
      required this.htmlEditorController,
      required this.htmlEditorOnInit});

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      controller: htmlEditorController,
      callbacks: Callbacks(onInit: htmlEditorOnInit),
    );
  }
}

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:smn_admin/const/myColors.dart';

class HtmlEditorWidget extends StatelessWidget {
  HtmlEditorController controller;
  String title;
  String? initialText;

  HtmlEditorWidget(
      {Key? key,
      required this.controller,
      required this.title,
      this.initialText})
      : super(key: key);
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 5),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: HtmlEditor(
                controller: controller,
                //required
                callbacks: Callbacks(
                  onInit: () {
                    controller.setFullScreen();
                  },
                  onEnter: (){
                    FocusScope.of(context).unfocus();
                    controller.setFocus();
                  }
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    // FontSettingButtons(),
                    // ColorButtons(),
                    StyleButtons(),
                    // ListButtons(),
                    ParagraphButtons(),
                    // InsertButtons(),
                    // OtherButtons(),
                  ],
                ),
                htmlEditorOptions: HtmlEditorOptions(
                    shouldEnsureVisible: true,
                    hint: '<p>' + title + '<p/>',
                    autoAdjustHeight: false,
                    initialText: initialText,
                    adjustHeightForKeyboard: false
                    //initalText: "text content initial, if any",
                    ),
                otherOptions: OtherOptions(
                  // decoration: BoxDecoration(color:Theme.of(context).brightness==Brightness.light?myColors.lightOrange: Theme.of(context).colorScheme.secondary),
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/customTextArea.dart';
import 'package:smn_admin/view/customWidget/customTextInput.dart';
import 'package:smn_admin/view/customWidget/html_editor_widget.dart';
import 'package:smn_admin/view/customWidget/pickerImageWidget.dart';

class CreateRestaurantFirstScreen extends StatefulWidget {
  const CreateRestaurantFirstScreen({Key? key}) : super(key: key);

  @override
  _CreateRestaurantFirstScreenState createState() =>
      _CreateRestaurantFirstScreenState();
}

class _CreateRestaurantFirstScreenState
    extends State<CreateRestaurantFirstScreen> {
  late AppLocalizations _trans;
  File? image;

  final TextEditingController nameAr = TextEditingController();
  final TextEditingController nameEn = TextEditingController();
  final TextEditingController descriptionEn = TextEditingController();
  final TextEditingController descriptionAr = TextEditingController();

  // HtmlEditorController descriptionEn = HtmlEditorController();
  // HtmlEditorController descriptionAr = HtmlEditorController();
  FocusNode nameArNode = FocusNode();
  FocusNode nameEnNode = FocusNode();
  FocusNode descriptionArNode = FocusNode();
  FocusNode descriptionEnNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('second_screen_details');
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PickerImageWidget(
                  title: _trans.upload_kitchen_image,
                  image: image,
                  onUpdateImage: (_image) {
                    image = _image;
                  },
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '1',
                                  style: TextStyle(color: myColors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: myColors.deepOrange),
                            ),
                            SizedBox(
                                width: config.App().appWidth(31),
                                child: Divider(
                                  color: myColors.deepOrange,
                                )),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '2',
                                  style: TextStyle(color: myColors.deepOrange),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: myColors.deepOrange)),
                            ),
                            SizedBox(
                                width: config.App().appWidth(31),
                                child: Divider(
                                  color: myColors.deepOrange,
                                )),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '3',
                                  style: TextStyle(color: myColors.deepOrange),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: myColors.deepOrange)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: config.App().appHeight(1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              _trans.create_your_kitchen,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      CustomTextInput(
                        onChanged: (input) {},
                        controller: nameEn,
                        validator: (text) {
                          if (text!.isEmpty && nameAr.text.isEmpty) {
                            return _trans.please_type_name_in_english;
                          }
                          return null;
                        },
                        hint: _trans.type_name_in_english,
                        title: _trans.name_in_english,
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextArea(
                        onChanged: (v) {},
                        hint: _trans.type_description_in_english,
                        title: _trans.description_in_english,
                        focusNode: descriptionEnNode,
                        controller: descriptionEn,
                        validator: (text) {
                          if (text!.isEmpty && descriptionAr.text.isEmpty) {
                            FocusScope.of(context)
                                .requestFocus(descriptionEnNode);
                            return _trans.please_type_description_in_english;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        textDirection: TextDirection.rtl,
                        onChanged: (input) {},
                        controller: nameAr,
                        validator: (text) {
                          if (text!.isEmpty && nameEn.text.isEmpty) {
                            return _trans.please_type_name_in_arabic;
                          }
                          return null;
                        },
                        title: _trans.name_in_arabic,
                        hint: _trans.type_name_in_arabic,
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextArea(
                        onChanged: (v) {},
                        textDirection: TextDirection.rtl,
                        hint: _trans.description_in_arabic,
                        title: _trans.description_in_arabic,
                        focusNode: descriptionArNode,
                        controller: descriptionAr,
                        validator: (text) {
                          if (text!.isEmpty && descriptionEn.text.isEmpty) {
                            FocusScope.of(context)
                                .requestFocus(descriptionArNode);
                            return _trans.please_type_description_in_arabic;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: config.App().appHeight(10),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(myColors.deepOrange)),
          onPressed: () async {
            if (image == null) {
              showToast(
                  context: context, message: _trans.please_upload_an_image);
              return;
            }
            if (_formKey.currentState!.validate()) {
              Navigator.pushNamed(context, 'CreateRestaurantSecondScreen',
                  arguments: {
                    "nameAr": nameAr.text,
                    "nameEn": nameEn.text,
                    "descriptionAr": descriptionAr.text,
                    "descriptionEn": descriptionEn.text,
                    "image": image,
                  });
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 10.0,
              ),
              Text(_trans.next),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

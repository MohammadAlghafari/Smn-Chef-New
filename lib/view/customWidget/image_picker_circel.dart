import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/image_from_network.dart';

class CirclePickerImageWidget extends StatefulWidget {
  Function onUpdateImage;
  File? image;
  String title;
  String ?url;

  CirclePickerImageWidget(
      {Key? key, required this.onUpdateImage,this.url, this.image, required this.title})
      : super(key: key);

  @override
  _CirclePickerImageWidgetState createState() =>
      _CirclePickerImageWidgetState();
}

class _CirclePickerImageWidgetState extends State<CirclePickerImageWidget> {
  final ImagePicker _picker = ImagePicker();
  late AppLocalizations _trans;

  // File? image;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showBottomSheetImagePicker(context);
          },
          child: Container(
            width: width,
            height: config.App().appHeight(34),
            decoration: BoxDecoration(
              color: myColors.orange,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.image == null&& widget.url==null ? Color(0xFFFFE6CB): myColors.deepOrange,
                    widget.image == null ? Color(0xFFFFE6CB) : myColors.white
                  ]),
            ),
            child: widget.image == null
                ? widget.url!=null? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: config.App().appHeight(5),
                ),
                Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(bottom: 25),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(99999.0),
                          child:  ImageFromNetworkWidget( widget.url!, config.App().appHeight(22),
                            config.App().appHeight(22),),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                myColors.deepOrange)),
                        onPressed: () {
                          _showBottomSheetImagePicker(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/img/edit_icon.png',
                              width: 20,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(_trans.edit_image),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ): Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/uploadImage.png',width: 55,),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: config.App().appHeight(5),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(99999.0),
                                child: Image.file(
                                  widget.image!,
                                  fit: BoxFit.cover,
                                  width: config.App().appHeight(22),
                                  height: config.App().appHeight(22),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          myColors.deepOrange)),
                              onPressed: () {

                                _showBottomSheetImagePicker(context);
                                FocusScope.of(context).unfocus();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/img/edit_icon.png',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(_trans.edit_image),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        Positioned(
          top: 33,
            child: IconButton(
              tooltip: _trans.back,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: myColors.white,)))
      ],
    );
  }

  void _showBottomSheetImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: myColors.orange,
                    ),
                    title: Text(_trans.gallery),
                    onTap: () async {
                      _imagePicker(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: myColors.orange,
                  ),
                  title: Text(_trans.camera),
                  onTap: () async {
                    _imagePicker(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _imagePicker(ImageSource imageSource) async {
    XFile? temp = await _picker.pickImage(source: imageSource,imageQuality: 10);
    if (temp != null) {
      widget.onUpdateImage(File(temp.path));
      setState(() {
        widget.image = File(temp.path);
      });
    }
  }
}

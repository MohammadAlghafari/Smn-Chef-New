import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/view/customWidget/image_from_network.dart';
import 'package:smn_admin/utili/app_config.dart'as config;


class PickerImageWidget extends StatefulWidget {
  Function onUpdateImage;
  File? image;
  String title;
  String? url;

  PickerImageWidget(
      {Key? key,
      required this.onUpdateImage,
      this.url,
      this.image,
      required this.title})
      : super(key: key);

  @override
  _PickerImageWidgetState createState() => _PickerImageWidgetState();
}

class _PickerImageWidgetState extends State<PickerImageWidget> {
  final ImagePicker _picker = ImagePicker();
  late AppLocalizations _trans;

  // File? image;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        _showBottomSheetImagePicker(context);
      },
      child: Stack(
        children: [
          getImageWidget(width),
          Positioned(
              top: 33,
              child: IconButton(
                tooltip:_trans.back,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('second_screen_details');
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: myColors.white,
                  )))
        ],
      ),
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

  Widget getImageWidget(double width) {
    if (widget.image == null && widget.url == null) {
      return SizedBox(
        height: config.App().appHeight(31),
        width: width,
        child:  Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6CB),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/uploadImage.png',
                width: 55,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18),
              )
            ],
          ),
        ),
      );
    }
    else if(widget.image == null &&widget.url !=null){
      return SizedBox(
        height: config.App().appHeight(31),
        width: width,
        child:  Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: ImageFromNetworkWidget(
                widget.url!,
                config.App().appWidth(100),
                config.App().appHeight(31),
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
                        borderRadius:
                        BorderRadius.circular(18.0),
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
      );
    }

    return SizedBox(
      height: config.App().appHeight(31),
      width: width,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              widget.image!,
              fit: BoxFit.cover,
              width: width,
            ),
          ),
          Positioned(
            bottom: 1,
            right: 21,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
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
    );
  }
}

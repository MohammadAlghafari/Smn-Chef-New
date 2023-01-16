import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/customTextInput.dart';
import 'package:smn_admin/view/customWidget/pickerImageWidget.dart';

class EditRestaurantSecondScreen extends StatefulWidget {
  File? image;
  Restaurant restaurant;

  EditRestaurantSecondScreen({
    Key? key,
    required this.restaurant,
    required this.image,
  }) : super(key: key);

  @override
  _EditRestaurantSecondScreenState createState() =>
      _EditRestaurantSecondScreenState();
}

class _EditRestaurantSecondScreenState
    extends State<EditRestaurantSecondScreen> {
  late AppLocalizations _trans;
  LocationResult? result;

  final TextEditingController addressCont = TextEditingController();
  final TextEditingController mobileCont = TextEditingController();
  final TextEditingController averageTimeCont = TextEditingController();
  final TextEditingController defaultTaxCont = TextEditingController();
  final TextEditingController phoneCont = TextEditingController();
  double? lat;
  double? lng;
  bool closedKitchen = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // loadDetailsFromShared();
    phoneCont.text=widget.restaurant.phone;
    mobileCont.text=widget.restaurant.mobile;
    averageTimeCont.text=widget.restaurant.avgTime;
    addressCont.text=widget.restaurant.address;
    lng=double.parse(widget.restaurant.longitude);
    lat=double.parse(widget.restaurant.latitude);
    super.initState();
  }

  @override
  void dispose() {
    addressCont.dispose();
    mobileCont.dispose();
    averageTimeCont.dispose();
    defaultTaxCont.dispose();
    phoneCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // PickerImageWidget(
              //   title: _trans.upload_kitchen_image,
              //   image: widget.image,
              //   onUpdateImage: (_image) {
              //     widget.image = _image;
              //   },
              // ),
              PickerImageWidget(
                title: _trans.upload_kitchen_image,
                image: widget.image,
                url: widget.restaurant.image.url,
                onUpdateImage: (_image) {
                  widget.image = _image;
                },
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                '3',
                                style: TextStyle(color: myColors.deepOrange),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: myColors.deepOrange)),
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
                            _trans.edit_your_kitchen,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    CustomTextInput(
                      textInputType: TextInputType.number,
                      onChanged: (input) {},
                      controller: phoneCont,
                      validator: (text) {
                        if (text!.isEmpty && mobileCont.text.isEmpty) {
                          return _trans.please_type_phone;
                        }
                        return null;
                      },
                      title: _trans.phone,
                      hint: _trans.type_phone,
                    ),
                    SizedBox(
                      height: config.App().appHeight(2),
                    ),
                    CustomTextInput(
                      textInputType: TextInputType.number,
                      onChanged: (input) {
                        // mobile = input;
                      },
                      controller: mobileCont,
                      validator: (text) {
                        if (text!.isEmpty && phoneCont.text.isEmpty) {
                          return _trans.please_type_mobile;
                        }
                        return null;
                      },
                      title: _trans.mobile,
                      hint: _trans.type_mobile,
                    ),
                    SizedBox(
                      height: config.App().appHeight(2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: addressCont,
                        textInputAction: TextInputAction.next,
                        readOnly: lat == null || lng == null ? true : false,
                        validator: (text) {
                          if (text!.isEmpty) return _trans.please_type_address;
                          return null;
                        },
                        onTap: () {
                          if (lat == null || lng == null) {
                            showPlacePicker();
                          }
                        },
                        decoration: InputDecoration(
                          labelText: _trans.address,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.my_location,
                              color: myColors.deepOrange,
                            ),
                            onPressed: () {
                              showPlacePicker();
                            },
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: const EdgeInsets.all(12),
                          hintText: _trans.type_address,
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: config.App().appHeight(2),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: config.App().appHeight(2),
                    ),
                    CustomTextInput(
                      textInputType: TextInputType.number,
                      onChanged: (input) {
                        // averageTime = input;
                      },
                      controller: averageTimeCont,
                      validator: (text) {
                        if (text!.isEmpty)
                          return _trans.please_type_average_time;
                        return null;
                      },
                      title: _trans.average_time,
                      hint: _trans.average_time_hint_preparation,
                      foramtter: FilteringTextInputFormatter.digitsOnly,
                    ),
                    // SizedBox(
                    //   height: config.App().appHeight(2),
                    // ),
                    // CustomTextInput(
                    //   textInputType: TextInputType.number,
                    //   onChanged: (input) {
                    //     // defaultTax = input;
                    //   },
                    //   controller: defaultTaxCont,
                    //   validator: (text) {
                    //   /*   if (text!.isEmpty)
                    //       return _trans.please_type_default_tax_of_the_kitchen;
                    //     return null; */
                    //   },
                    //   title: _trans.default_tax_of_the_kitchen,
                    //   hint: _trans.type_default_tax_of_the_kitchen,
                    // ),
                    // SizedBox(
                    //   height: config.App().appHeight(3),
                    // ),
                    // const Divider(
                    //   color: Colors.grey,
                    // ),
                    // CustomCheckBox(
                    //     title: _trans.closed_kitchen,
                    //     onChange: (v) {
                    //       closedKitchen = v;
                    //     }),
                    SizedBox(
                      height: config.App().appHeight(10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   child: Text(_trans.back,style: TextStyle(color: myColors.orange,fontWeight: FontWeight.w700),),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(myColors.deepOrange)),
              onPressed: () {
                saveScreensDetails();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios),
                  Text(_trans.back),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(myColors.deepOrange)),
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              //   Navigator.pushNamed(context, 'CreateRestaurantThirdScreen',
              //       arguments: {
              //         "nameAr": widget.nameAr,
              //         "nameEn": widget.nameEn,
              //         "descriptionAr": widget.descriptionAr,
              //         "descriptionEn": widget.descriptionEn,
              //         "image": widget.image,
              //         "address": addressCont.text,
              //         "phone": phoneCont.text,
              //         "mobile": mobileCont.text,
              //         "averageTime": averageTimeCont.text,
              //         "defaultTax": defaultTaxCont.text.isEmpty
              //             ? '0'
              //             : defaultTaxCont.text,
              //         "lat": lat,
              //         "lng": lng,
              //       });
              // }
              if (_formKey.currentState!.validate()) {
                widget.restaurant.address = addressCont.text;
                widget.restaurant.phone = phoneCont.text;
                widget.restaurant.mobile = mobileCont.text;
                widget.restaurant.avgTime = averageTimeCont.text;
                widget.restaurant.latitude = lat.toString();
                widget.restaurant.longitude = lng.toString();

                Navigator.pushNamed(context, 'EditRestaurantThirdScreen',
                    arguments: {
                      "restaurant": widget.restaurant,
                      "image": widget.image,
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
        ],
      ),
    );
  }

  void showPlacePicker() async {
    result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PlacePicker(
                "AIzaSyD_lRvTskGkN80rrp59iaaMPyG8SmzZRQE",
              )),
    );
    if (result != null && result!.formattedAddress != null) {
      addressCont.text = result!.formattedAddress!;
      lat = result!.latLng!.latitude;
      lng = result!.latLng!.longitude;
    }
  }

  void saveScreensDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "second_screen_details",
        json.encode({
          "address": addressCont.text,
          "phone": phoneCont.text,
          "mobile": mobileCont.text,
          "averageTime": averageTimeCont.text,
          "defaultTax": defaultTaxCont.text,
          "lat": lat,
          "lng": lng,
        }));
    Navigator.pop(context);
  }

  void loadDetailsFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('second_screen_details') != null) {
      final res = json.decode(prefs.getString('second_screen_details')!);
      addressCont.text = res['address'];
      phoneCont.text = res['phone'];
      mobileCont.text = res['mobile'];
      averageTimeCont.text = res['averageTime'];
      defaultTaxCont.text = res['defaultTax'];
      lat = res['lat'];
      lng = res['lng'];
      setState(() {});
    }
  }
}

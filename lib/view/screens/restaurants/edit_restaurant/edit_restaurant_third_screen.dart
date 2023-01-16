import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/pickerImageWidget.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';

class EditRestaurantThirdScreen extends StatefulWidget {
  File? image;
  Restaurant restaurant;

  EditRestaurantThirdScreen({
    Key? key,
    required this.restaurant,
    required this.image,
  }) : super(key: key);

  @override
  _EditRestaurantThirdScreenState createState() =>
      _EditRestaurantThirdScreenState();
}

class _EditRestaurantThirdScreenState extends State<EditRestaurantThirdScreen> {
  late AppLocalizations _trans;

  bool availableForDelivery = true;
  final TextEditingController addressCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List<Cuisine> _cuisines = [];
  List<Cuisine> _selectedCuisines = [];
  List<EmiratesDeliveryFee> _selectedEmiratesDeliveryFee = [];
  List<String> emiratesEnglishName = [
    'abu_dhabi',
    'dubai',
    'sharjah',
    'ajman',
    'umm_al_quwain',
    'ras_al_khaimah',
    'fujairah',
  ];

  @override
  void initState() {
    // loadData();
    // widget.restaurant.c
    _selectedCuisines = widget.restaurant.cuisines;
    // availableForDelivery = !widget.restaurant.availableForDelivery;
    super.initState();
  }

  @override
  void dispose() {
    addressCont.dispose();
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
              //   image: widget.image,
              //   title: _trans.upload_kitchen_image,
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
                                style: TextStyle(color: myColors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: myColors.deepOrange),
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
                    SizedBox(
                      height: config.App().appHeight(1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _trans.cuisines,
                        style:
                            TextStyle(color: myColors.deepOrange, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: config.App().appHeight(1),
                    ),
                    Consumer<RestaurantsViewModel>(
                      builder: (context, restaurantModel, child) {
                        return cuisinesWidget(restaurantModel.cuisines);
                      },
                    ),
                    // SizedBox(
                    //   height: config.App().appHeight(2),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         _trans.i_do_not_have_delivery_service,
                    //         style: TextStyle(
                    //             color: myColors.deepOrange, fontSize: 18),
                    //       ),
                    //       Checkbox(
                    //           value: availableForDelivery,
                    //           onChanged: (v) {
                    //             if (v!) {
                    //               for (int i = 0;
                    //                   i < _selectedEmiratesDeliveryFee.length;
                    //                   i++) {
                    //                 _selectedEmiratesDeliveryFee[i].isEnable =
                    //                     false;
                    //                 _selectedEmiratesDeliveryFee[i]
                    //                     .deliveryFee
                    //                     .clear();
                    //               }
                    //             }
                    //             setState(() {
                    //               availableForDelivery = v;
                    //             });
                    //           })
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: config.App().appHeight(2),
                    // ),
                    // availableForDelivery
                    //     ? Container()
                    //     : Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 12),
                    //         child: Text(
                    //           _trans.emirates_delivery_fee,
                    //           style: TextStyle(
                    //               color: myColors.deepOrange, fontSize: 18),
                    //         ),
                    //       ),
                    // availableForDelivery ? Container() : emiratesDevFeeWidget(),
                    // SizedBox(
                    //   height: config.App().appHeight(9),
                    // ),
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
                Navigator.pop(context);
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
              if (_selectedCuisines.isEmpty) {
                showToast(
                    context: context, message: _trans.please_choose_cuisine);
                return;
              }
              // if (!availableForDelivery) {
              //   bool validateEmiratesDeliveryFee = true;
              //   for (var element in _selectedEmiratesDeliveryFee) {
              //     if (element.isEnable) validateEmiratesDeliveryFee = false;
              //   }
              //   if (validateEmiratesDeliveryFee) {
              //     showToast(
              //         context: context,
              //         message: _trans.add_emirates_delivery_fee);
              //     return;
              //   }
              // }

              if (_formKey.currentState!.validate()) {
                buildShowDialog(context);
                widget.restaurant.availableForDelivery=!availableForDelivery;
                Provider.of<RestaurantsViewModel>(context, listen: false)
                    .editRestaurant(widget.restaurant, widget.image,
                        emiratesToString(), _selectedCuisines, context);
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

  Widget cuisinesWidget(List<Cuisine> cuisines) {
    if (cuisines.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          children: cuisines
              .map((e) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              _selectedCuisines.contains(e)
                                  ? myColors.deepOrange
                                  : myColors.white)),
                      onPressed: () {
                        setState(() {
                          if (_selectedCuisines.contains(e)) {
                            _selectedCuisines.remove(e);
                          } else {
                            _selectedCuisines.add(e);
                          }
                        });
                      },
                      child: Text(
                        e.name,
                        style: TextStyle(
                            color: _selectedCuisines.contains(e)
                                ? myColors.white
                                : myColors.deepOrange),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    }
    return Container();
  }

  Widget emiratesDevFeeWidget() {
    List<String> emiratesName = [
      _trans.abu_dhabi,
      _trans.dubai,
      _trans.sharjah,
      _trans.ajman,
      _trans.umm_al_quwain,
      _trans.ras_al_khaimah,
      _trans.fujairah,
    ];

    if (availableForDelivery) {
      _selectedEmiratesDeliveryFee.addAll(emiratesName
          .map((e) => EmiratesDeliveryFee.fromJSON({
                'emirateName': e,
                'englishName': emiratesEnglishName[emiratesName.indexOf(e)],
                'deliveryFee': '0',
              }))
          .toList());
    }
    if (_selectedEmiratesDeliveryFee.isEmpty &&
        widget.restaurant.deliveryFee.isNotEmpty) {
      widget.restaurant.deliveryFee =
          widget.restaurant.deliveryFee.replaceAll('{', '');
      widget.restaurant.deliveryFee =
          widget.restaurant.deliveryFee.replaceAll('}', '');
      widget.restaurant.deliveryFee =
          widget.restaurant.deliveryFee.replaceAll('\"', '');
      List<String> temp1 = widget.restaurant.deliveryFee.split(',');
      List<String> cities = [];
      List<String> fee = [];
      for (var element in temp1) {
        cities.add(element.split(':')[0].replaceAll(' ',''));
        fee.add(element.split(':')[1]);
      }
      _selectedEmiratesDeliveryFee.addAll(emiratesName
          .map((e) => EmiratesDeliveryFee.fromJSON({
                'emirateName': e,
                'englishName': emiratesEnglishName[emiratesName.indexOf(e)],
                'deliveryFee': '0',
              }))
          .toList());
      for (int i = 0; i < _selectedEmiratesDeliveryFee.length; i++) {
        if (cities.contains(_selectedEmiratesDeliveryFee[i].englishName)) {
          _selectedEmiratesDeliveryFee[i].deliveryFee.text =
              fee[cities.indexOf(_selectedEmiratesDeliveryFee[i].englishName)];
          _selectedEmiratesDeliveryFee[i].isEnable = true;
        }
      }
    }

    if (_selectedEmiratesDeliveryFee.isNotEmpty) {
      return Column(
        children: emiratesName
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .isEnable = true;
                        });
                      },
                      keyboardType: TextInputType.number,
                      controller:
                          _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .deliveryFee,
                      textInputAction: TextInputAction.next,
                      validator: (text) {
                        if (text!.isEmpty &&
                            _selectedEmiratesDeliveryFee[
                                    emiratesName.indexOf(e)]
                                .isEnable) return _trans.please_type_delivery_fee;
                        return null;
                      },
                      // enabled: _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                      //     .isEnable,
                      cursorColor: myColors.deepOrange,
                      focusNode:
                          _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .focusNode,
                      readOnly:
                          !_selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .isEnable,
                      decoration: InputDecoration(
                        labelText: e,
                        suffixIcon: Checkbox(
                          value: _selectedEmiratesDeliveryFee[
                                  emiratesName.indexOf(e)]
                              .isEnable,
                          onChanged: (bool? value) {
                            if (availableForDelivery) return;
                            setState(() {
                              _selectedEmiratesDeliveryFee[
                                      emiratesName.indexOf(e)]
                                  .isEnable = value!;

                              print(_selectedEmiratesDeliveryFee[
                                      emiratesName.indexOf(e)]
                                  .isEnable);
                              if (!value) {
                                _selectedEmiratesDeliveryFee[
                                        emiratesName.indexOf(e)]
                                    .deliveryFee
                                    .clear();
                              } else {
                                FocusScope.of(context).unfocus();
                                FocusScope.of(context).requestFocus(
                                    _selectedEmiratesDeliveryFee[
                                            emiratesName.indexOf(e)]
                                        .focusNode);
                              }
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        contentPadding: const EdgeInsets.all(12),
                        hintText: _trans.delivery_fee_to + ' ' + e,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
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
                ))
            .toList(),
      );
    }

    return Container();
  }

  // void loadData() async {
  //   _cuisines = await Provider.of<AuthViewModel>(context, listen: false)
  //       .getCuisines()
  //       .whenComplete(() {
  //     setState(() {
  //     });
  //   });
  // }

  List<EmiratesDeliveryFee> emiratesToString() {
    List<EmiratesDeliveryFee> temp = [];
    for (var element in _selectedEmiratesDeliveryFee) {
      if (element.isEnable) temp.add(element);
    }
    return temp;
  }
}

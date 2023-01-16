import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/models/media.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/pickerImageWidget.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';

class CreateRestaurantThirdScreen extends StatefulWidget {
  File image;
  String nameAr;
  String nameEn;
  String descriptionAr;
  String descriptionEn;
  String phone;
  String mobile;
  String averageTime;
  String defaultTax;
  String address;
  double lat;
  double lng;

  CreateRestaurantThirdScreen({
    Key? key,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    required this.mobile,
    required this.phone,
    required this.address,
    required this.defaultTax,
    required this.averageTime,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  _CreateRestaurantThirdScreenState createState() =>
      _CreateRestaurantThirdScreenState();
}

class _CreateRestaurantThirdScreenState
    extends State<CreateRestaurantThirdScreen> {
  late AppLocalizations _trans;

  bool noDeliveryService = false;
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
              PickerImageWidget(
                image: widget.image,
                title: _trans.upload_kitchen_image,
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
                    //   padding: const EdgeInsets.symmetric(horizontal: 18),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         _trans.i_do_not_have_delivery_service,
                    //         style: TextStyle(
                    //             color: myColors.deepOrange, fontSize: 18),
                    //       ),
                    //       Checkbox(
                    //           value: noDeliveryService,
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
                    //               noDeliveryService = v;
                    //             });
                    //           })
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: config.App().appHeight(2),
                    // ),
                    // noDeliveryService
                    //     ? Container()
                    //     : Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 12),
                    //         child: Text(
                    //           _trans.emirates_delivery_fee,
                    //           style: TextStyle(
                    //               color: myColors.deepOrange, fontSize: 18),
                    //         ),
                    //       ),
                    // emiratesDevFeeWidget(),
                    SizedBox(
                      height: config.App().appHeight(6),
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
              // if (!noDeliveryService) {
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

                Provider.of<RestaurantsViewModel>(context, listen: false)
                    .createRestaurant(
                        Restaurant(
                            id: '',
                            descriptionEn: "",
                            nameEn: '',
                            deliveryCities: '',
                            name: widget.nameEn,
                            image: Media.fromJSON({}),
                            rate: '0',
                            address: widget.address,
                            description: widget.descriptionEn,
                            phone: widget.phone,
                            mobile: widget.mobile,
                            information: widget.averageTime,
                            deliveryFee:
                                jsonEncode(_selectedEmiratesDeliveryFee),
                            adminCommission: 0,
                            defaultTax: double.parse(widget.defaultTax),
                            latitude: widget.lat.toString(),
                            longitude: widget.lng.toString(),
                            closed: false,
                            // availableForDelivery: !noDeliveryService,
                            availableForDelivery: true,
                            deliveryRange: 0,
                            distance: 1,
                            users: [],
                            addressArb: widget.address,
                            descriptionArb: widget.descriptionAr,
                            nameArb: widget.nameAr,
                            cuisines: _selectedCuisines,
                            avgTime: widget.averageTime),
                        widget.image,
                        emiratesToString(),
                        _selectedCuisines,
                        context);
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

    if (_selectedEmiratesDeliveryFee.isEmpty) {
      _selectedEmiratesDeliveryFee.addAll(emiratesName
          .map((e) => EmiratesDeliveryFee.fromJSON({
                'emirateName': e,
                'englishName': emiratesEnglishName[emiratesName.indexOf(e)],
                'deliveryFee': '0',
              }))
          .toList());
    }

    if (_selectedEmiratesDeliveryFee.isNotEmpty && !noDeliveryService) {
      return Column(
        children: emiratesName
            .map((e) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onTap: () {
                        setState(() {
                          _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .isEnable = true;
                        });
                      },
                      controller:
                          _selectedEmiratesDeliveryFee[emiratesName.indexOf(e)]
                              .deliveryFee,
                      textInputAction: TextInputAction.next,
                      validator: (text) {
                        if (text!.isEmpty &&
                            _selectedEmiratesDeliveryFee[
                                    emiratesName.indexOf(e)]
                                .isEnable) return _trans.please_type_address;
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
                            if (noDeliveryService) return;
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/models/media.dart';
import 'package:smn_admin/data/order/model/category.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/customTextArea.dart';
import 'package:smn_admin/view/customWidget/customTextInput.dart';
import 'package:smn_admin/view/customWidget/html_editor_widget.dart';
import 'package:smn_admin/view/customWidget/image_picker_circel.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';


class EditFoodScreen extends StatefulWidget {
  Food food;

  EditFoodScreen({Key? key, required this.food}) : super(key: key);

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late AppLocalizations _trans;
  File? image;
  final TextEditingController nameAr = TextEditingController();
  final TextEditingController nameEn = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController discountPrice = TextEditingController();
  final TextEditingController packageCount = TextEditingController();
  final TextEditingController weight = TextEditingController();

  final TextEditingController descriptionEn = TextEditingController();
  final TextEditingController descriptionAr = TextEditingController();
  final TextEditingController ingredientsEn = TextEditingController();
  final TextEditingController ingredientsAr = TextEditingController();

  Category? category;
  FocusNode nameArNode = FocusNode();
  FocusNode nameEnNode = FocusNode();
  FocusNode descriptionArNode = FocusNode();
  FocusNode descriptionEnNode = FocusNode();
  FocusNode ingredientsEnNode = FocusNode();
  FocusNode ingredientsArNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode packageCountNode = FocusNode();
  FocusNode weightNode = FocusNode();

  bool featuredFood = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> units = ['L', 'ml', 'g', 'Kg'];
  String? unit;

  @override
  void initState() {
    Provider.of<RestaurantsViewModel>(context, listen: false).getCategories();
    nameAr.text = widget.food.nameAr;
    nameEn.text = widget.food.nameEn;
    price.text = widget.food.price.toString();
    discountPrice.text = widget.food.discountPrice.toString();
    unit = widget.food.unit;
    featuredFood = widget.food.featured;
    packageCount.text = widget.food.packageItemsCount;
    weight.text = widget.food.weight;
    descriptionEn.text=widget.food.descriptionEn;
    descriptionAr.text=widget.food.descriptionAr;
    ingredientsAr.text=widget.food.ingredientsAr;
    ingredientsEn.text=widget.food.ingredientsEn;
    super.initState();
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
            children: [
              CirclePickerImageWidget(
                title: _trans.upload_food_image,
                image: image,
                url: widget.food.image.url!,
                onUpdateImage: (_image) {
                  image = _image;
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: config.App().appHeight(1),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              _trans.edit_food,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // nameEn = input;
                        },
                        controller: nameEn,
                        focusNode: nameEnNode,
                        validator: (text) {
                          if (text!.isEmpty && nameAr.text.isEmpty) {
                            FocusScope.of(context).requestFocus(nameEnNode);
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

                      CustomTextArea(onChanged: (v) {},
                        hint: _trans.type_description_in_english,
                        title: _trans.description_in_english,
                        focusNode: descriptionEnNode,
                        controller: descriptionEn,
                        validator: (text) {
                          if (text!.isEmpty && descriptionAr.text.isEmpty) {
                            FocusScope.of(context).requestFocus(descriptionEnNode);
                            return _trans.please_type_description_in_english;
                          }
                          return null;
                        },),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // nameAr = input;
                        },
                        textDirection: TextDirection.rtl,

                        focusNode: nameArNode,
                        controller: nameAr,
                        validator: (text) {
                          if (text!.isEmpty && nameEn.text.isEmpty) {
                            FocusScope.of(context).requestFocus(nameArNode);

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
                      CustomTextArea(onChanged: (v) {},
                        hint: _trans.description_in_arabic,
                        title: _trans.description_in_arabic,
                        focusNode: descriptionArNode,
                        controller: descriptionAr,
                        textDirection: TextDirection.rtl,

                        validator: (text) {
                          if (text!.isEmpty && descriptionEn.text.isEmpty) {
                            FocusScope.of(context).requestFocus(descriptionArNode);
                            return _trans.please_type_description_in_arabic;
                          }
                          return null;
                        },),


                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextArea(
                          onChanged: (input) {
                            // ingredientsEn = input;
                          },
                          controller: ingredientsEn,
                          hint: _trans.insert_ingredients_in_english,
                          title: _trans.ingredients_in_english,
                          focusNode: ingredientsEnNode,
                          validator: (text) {
                            // if (text!.isEmpty) {
                            //   return _trans.please_insert_ingredients_in_english;
                            // }
                            return null;
                          }),

                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextArea(
                          onChanged: (input) {
                            // ingredientsAr = input;
                          },
                          textDirection: TextDirection.rtl,

                          controller: ingredientsAr,
                          hint: _trans.ingredients_in_arabic,
                          title: _trans.ingredients_in_arabic,
                          focusNode: ingredientsArNode,
                          validator: (text) {
                            // if (text!.isEmpty) {
                            //   return _trans.please_insert_ingredients_in_arabic;
                            // }
                            return null;
                          }),


                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // price = double.parse(input!);
                        },
                        focusNode: priceNode,
                        controller: price,
                        textInputType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            FocusScope.of(context).requestFocus(priceNode);

                            return _trans.please_enter_price;
                          }
                          return null;
                        },
                        title: _trans.price,
                        hint: _trans.enter_price,
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // discountPrice = double.parse(input!);
                        },
                        controller: discountPrice,
                        textInputType: TextInputType.number,
                        validator: (text) {
                          if (text!.isNotEmpty&& double.parse(text)>=double.parse(price.text)) {
                            return _trans.discount_price_should_be_less_than_price;
                          }
                          return null;
                        },
                        title: _trans.discount_price,
                        hint: _trans.enter_discount_price,
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).highlightColor)),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).highlightColor)),
                          ),
                          items: units.map((item) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                item,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              value: item,
                            );
                          }).toList(),
                          hint: Text(
                            _trans.unit,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          iconSize: 30,
                          onChanged: (newVal) {
                            setState(() {
                              unit = newVal;
                            });
                          },
                          value: unit,
                        ),
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // nameAr = input;
                          // packageCount = int.parse(input!);
                        },
                        focusNode: packageCountNode,
                        controller: packageCount,
                        textInputType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            FocusScope.of(context)
                                .requestFocus(packageCountNode);

                            return _trans.please_number_of_item_per_package;
                          }
                          return null;
                        },
                        title: _trans.package_count,
                        hint: _trans.number_of_item_per_package,
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      CustomTextInput(
                        onChanged: (input) {
                          // nameAr = input;
                          // weight = double.parse(input!);
                        },
                        controller: weight,
                        focusNode: weightNode,
                        textInputType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            FocusScope.of(context).requestFocus(weightNode);

                            return _trans.please_insert_weight_of_this_food;
                          }
                          return null;
                        },
                        title: _trans.weight,
                        hint: _trans
                            .insert_weight_of_this_food_default_unit_is_gramme,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              _trans.featuredFoods,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Checkbox(
                              value: featuredFood,
                              onChanged: (v) {
                                setState(() {
                                  featuredFood = v!;
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: config.App().appHeight(2),
                      ),
                      Consumer<RestaurantsViewModel>(
                        builder: (context, restaurantModel, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<Category>(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor)),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor)),
                              ),
                              items: restaurantModel.categories.map((item) {
                                return DropdownMenuItem<Category>(
                                  child: Text(
                                    item.name,
                                    style:
                                        TextStyle(color: Colors.grey[600]),
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              hint: Text(
                                _trans.insert_category,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              iconSize: 30,
                              onChanged: (newVal) {
                                setState(() {
                                  category = newVal;
                                });
                              },
                              value: restaurantModel.categories.firstWhere(
                                  (element) =>
                                      element.id == widget.food.category.id),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: config.App().appHeight(10),
                      ),
                    ],
                  ),
                ),
              ),
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
          if (_formKey.currentState!.validate()) {
            Food food = Food(
              nameEn: '',
              descriptionEn: '',
              ingredientsEn: '',
                name: nameEn.text,
                nameAr: nameAr.text,
                image: Media.fromJSON({}),
                description: descriptionEn.text,
                // descriptionEn: (await keyEditor.currentState?.getHtml())??'',
                descriptionAr: descriptionAr.text,
                id: widget.food.id,
                price: double.parse(price.text),
                extras: [],
                active: false,
                category: category ?? widget.food.category,
                deliverable: true,
                discountPrice: discountPrice.text.isNotEmpty
                    ? double.parse(discountPrice.text)
                    : 0,
                extraGroups: [],
                featured: featuredFood,
                foodReviews: [],
                ingredients:  ingredientsEn.text,
                ingredientsAr:  ingredientsAr.text,
                nutritions: [],
                packageItemsCount: packageCount.text,
                restaurant: Restaurant.fromJSON({}),
                unit: unit.toString(),
                weight: weight.text);
            // Navigator.pushNamed(context, 'CreateRestaurantSecondScreen',
            //     arguments: {
            //       "nameAr": nameAr,
            //       "nameEn": nameEn,
            //       "descriptionAr": descriptionAr,
            //       "descriptionEn": descriptionEn,
            //       "image": image,
            //     });
            buildShowDialog(context);
            Provider.of<RestaurantsViewModel>(context, listen: false)
                .editFood(food: food, image: image);
          }
        },
        child: Text(_trans.edit_food),
      ),
    );
  }

  @override
  void dispose() {
    nameAr.dispose();
    nameEn.dispose();
    price.dispose();
    discountPrice.dispose();
    packageCount.dispose();
    weight.dispose();
    nameArNode.dispose();
    nameEnNode.dispose();
    priceNode.dispose();
    packageCountNode.dispose();
    weightNode.dispose();
    super.dispose();
  }
}

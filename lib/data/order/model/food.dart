import 'package:smn_admin/data/models/media.dart';
import 'package:smn_admin/data/order/model/review.dart';

import '../../order/model/category.dart';
import '../../order/model/extra.dart';
import 'extra_group.dart';
import 'nutrition.dart';
import '../../restaurants/model/restaurant.dart';

class Food {
  String id;
  String name;
  String nameEn;
  String nameAr;
  double price;
  double discountPrice;
  Media image;
  String description;
  String descriptionEn;
  String descriptionAr;
  String ingredients;
  String ingredientsEn;
  String ingredientsAr;
  String weight;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  bool active;
  Restaurant restaurant;
  Category category;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;

  Food(
      {required this.name,
      required this.nameAr,
      required this.image,
      required this.descriptionEn,
      required this.ingredientsEn,
      required this.description,
      required this.descriptionAr,
      required this.id,
      required this.price,
      required this.extras,
      required this.nameEn,
      required this.category,
      required this.deliverable,
      required this.discountPrice,
      required this.extraGroups,
      required this.active,
      required this.featured,
      required this.foodReviews,
      required this.ingredients,
      required this.ingredientsAr,
      required this.nutritions,
      required this.packageItemsCount,
      required this.restaurant,
      required this.unit,
      required this.weight});

  factory Food.fromJSON(Map<String, dynamic> jsonMap) {
    return Food(
      id: jsonMap['id'].toString(),
      name: jsonMap['name'] ?? "",
      nameEn: jsonMap['name_en'] ?? "",
      descriptionEn: jsonMap['description_en'] ?? "",
      ingredientsEn: jsonMap['ingredients_en'] ?? "",

      active: jsonMap['active'] ?? false,
      nameAr: jsonMap['name_ar'] ?? "",
      price: jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0,
      discountPrice: jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0,
      description: jsonMap['description'] ?? "",
      descriptionAr: jsonMap['description_ar'] ?? "",
      ingredients: jsonMap['ingredients'] ?? "",
      ingredientsAr: jsonMap['ingredients_ar'] ?? "",
      weight: jsonMap['weight'] != null ? jsonMap['weight'].toString() : '',
      unit: jsonMap['unit'] != null ? jsonMap['unit'].toString() : '',
      packageItemsCount: jsonMap['package_items_count'].toString(),
      featured: jsonMap['featured'] ?? false,
      deliverable: jsonMap['deliverable'] ?? false,
      restaurant: jsonMap['restaurant'] != null
          ? Restaurant.fromJSON(jsonMap['restaurant'])
          : Restaurant.fromJSON({}),
      category: jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : Category.fromJSON({}),
      image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : Media(),
      extras:
          jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
              ? List.from(jsonMap['extras'])
                  .map((element) => Extra.fromJSON(element))
                  .toSet()
                  .toList()
              : [],
      extraGroups: jsonMap['extra_groups'] != null &&
              (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups'])
              .map((element) => ExtraGroup.fromJSON(element))
              .toSet()
              .toList()
          : [],
      foodReviews: jsonMap['food_reviews'] != null &&
              (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews'])
              .map((element) => Review.fromJSON(element))
              .toSet()
              .toList()
          : [],
      nutritions: jsonMap['nutrition'] != null &&
              (jsonMap['nutrition'] as List).isNotEmpty
          ? List.from(jsonMap['nutrition'])
              .map((element) => Nutrition.fromJSON(element))
              .toSet()
              .toList()
          : [],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }

  double getRate() {
    double _rate = 0;
    foodReviews.forEach((e) => _rate += double.parse(e.rate));
    _rate = _rate > 0 ? (_rate / foodReviews.length) : 0;
    return _rate;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}

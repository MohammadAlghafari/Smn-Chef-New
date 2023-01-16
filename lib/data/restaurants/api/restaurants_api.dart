import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/order/model/category.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/order/model/review.dart';
import 'package:smn_admin/data/restaurants/model/gallery.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';

import '../../../smn_chef.dart';

class RestaurantsApi {
  AuthViewModel authViewModel;
  Dio dio;

  RestaurantsApi({required this.authViewModel, required this.dio});

  Future<List<Restaurant>> getRestaurants() async {
    Uri uri = Helper.getUri('api/manager/restaurants');
    Map<String, dynamic> _queryParams = {};

    if (authViewModel.user!.apiToken == null) {
      return [];
    }
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    _queryParams['orderBy'] = 'id';
    _queryParams['sortedBy'] = 'desc';
    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Restaurant>((json) => Restaurant.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<Restaurant> getRestaurant(String id) async {
    Uri uri = Helper.getUri('api/manager/restaurants/$id');
    Map<String, dynamic> _queryParams = {
      'api_token': authViewModel.user!.apiToken
    };
    _queryParams['with'] = 'users';
    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.getUri(uri);
      return Restaurant.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Restaurant.fromJSON({});
    }
  }

  Future<List<Review>> getRestaurantReviews(String id) async {
    Uri uri = Helper.getUri('api/restaurant_reviews');
    Map<String, dynamic> _queryParams = {};
    _queryParams['with'] = 'user';
    _queryParams['search'] = 'restaurant_id:$id';
    _queryParams['limit'] = '5';
    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Review>((json) => Review.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Gallery>> getGalleries(String idRestaurant) async {
    Map<String, dynamic> _queryParams = {};
    Uri uri = Helper.getUri('api/galleries');
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    _queryParams['search'] = 'restaurant_id:$idRestaurant';

    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Gallery>((json) => Gallery.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/manager/foods');
    uri = uri.replace(queryParameters: {
      'with': 'category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
      'api_token': authViewModel.user!.apiToken
    });

    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Food>((json) => Food.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Cuisine>> getCuisines() async {
    Uri uri = Uri.parse(url.getCuisines());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      print(response.data);
      return (response.data['data'] as List)
          .map<Cuisine>((json) => Cuisine.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Category>> getCategories() async {
    Uri uri = Uri.parse(url.getCategories());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      print(response.data);
      return (response.data['data'] as List)
          .map<Category>((json) => Category.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<bool> createFood(
      {required File image,
      required Food food,
      required String restaurantId}) async {
    Uri uri = Uri.parse(url.createFood());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);

    String fileName = image.path.split('/').last;

    FormData formData = FormData.fromMap({
      'name': food.name,
      'name_ar': food.nameAr,
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
      'price': food.price,
      'discount_price': food.discountPrice,
      'description': food.description,
      'description_ar': food.descriptionAr,
      'ingredients': food.ingredients,
      'ingredients_ar': food.ingredientsAr,
      'weight': food.weight,
      'package_items_count': food.packageItemsCount,
      'unit': food.unit,
      'featured': food.featured ? 1 : 0,
      'deliverable': true,
      'restaurant_id': restaurantId,
      'category_id': food.category.id,
      'active': false
    });
    try {
      final response = await dio.postUri(uri, data: formData);
      print(response.data);
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      print(response.response!.data);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> editFood(
      {required File? image,
      required Food food,
      required String restaurantId}) async {
    Uri uri = Uri.parse(url.editFood(food.id));
    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    uri = uri.replace(queryParameters: _queryParams);
    Map<String, dynamic> myJson = {
      'name': food.name,
      'name_ar': food.nameAr,
      'price': food.price.toString(),
      'discount_price': food.discountPrice.toString(),
      'description': food.description,
      'description_ar': food.descriptionAr,
      'ingredients': food.ingredients,
      'ingredients_ar': food.ingredientsAr,
      'weight': food.weight.toString(),
      'package_items_count': food.packageItemsCount.toString(),
      'unit': food.unit,
      'featured': food.featured,
      'deliverable': true,
      'restaurant_id': restaurantId,
      'category_id': food.category.id,
      'active': 0
    };
    if (image != null) {
      String fileName = image.path.split('/').last;
      myJson['image'] =
          await MultipartFile.fromFile(image.path, filename: fileName);
    }
    FormData formData = FormData.fromMap(myJson);
    try {
      final response = await dio.postUri(uri, data: formData);
      print(response.data);
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> deleteFood(String foodId) async {
    try {
      //https://staging.smnfood.app/api/manager/foods/243
      Uri uri = Uri.parse(url.deleteFood(foodId));
      Map<String, dynamic> _queryParams = {};
      _queryParams['api_token'] = authViewModel.user!.apiToken;
      uri = uri.replace(queryParameters: _queryParams);
      final response = await dio.deleteUri(uri);
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> createRestaurant(
      Restaurant restaurant,
      File image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee,
      List<Cuisine> cuisines) async {
    Uri uri = Uri.parse(url.createRestaurant());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);

    String fileName = image.path.split('/').last;
    String cus = '';
    for (var element in cuisines) {
      cus += element.id + ',';
    }

    cus = cus.substring(0, cus.length - 1);

    Map<String, dynamic> deliveryFeeMap = {};
    for (var element in emiratesDeliveryFee) {
      deliveryFeeMap[element.englishName.toLowerCase().replaceAll(' ', '_')] =
          element.deliveryFee.text;
    }

    List<String> deliveryCitiesMap = [];
    for (var element in emiratesDeliveryFee) {
      deliveryCitiesMap.add(element.englishName);
    }

    Map<String, String> deliveryCities = {};
    for (var i = 0; i < deliveryCitiesMap.length; i++) {
      deliveryCities['$i'] = deliveryCitiesMap[i];
    }
    Map<String, dynamic> mapJson = {
      "name": restaurant.name,
      "name_arb": restaurant.nameArb,
      "description": restaurant.description,
      "description_arb": restaurant.descriptionArb,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
      'address': restaurant.address,
      'arb_address': restaurant.addressArb,
      'latitude': restaurant.latitude,
      'longitude': restaurant.longitude,
      'phone': restaurant.phone,
      'mobile': restaurant.mobile,
      'admin_commission': 0.0,
      'cuisines': cus,
      // 'delivery_fee': deliveryFeeMap,
      // 'delivery_cities': deliveryCities,
      'default_tax': restaurant.defaultTax,
      'delivery_range': '0',
      // 'available_for_delivery': restaurant.availableForDelivery?1:0,
      'available_for_delivery': 1,
      'closed': restaurant.closed,
      'information': restaurant.information,
      'active': false,
      'avg_time': restaurant.avgTime,
    };
    // if (deliveryCitiesMap.isNotEmpty) {
    //   mapJson['delivery_fee'] = deliveryFeeMap;
    //   mapJson['delivery_cities'] = deliveryCities;
    // }
    FormData formData = FormData.fromMap(mapJson);

    try {
      final response = await dio.postUri(uri, data: formData);
      print(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('second_screen_details');
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> editRestaurant(
      Restaurant restaurant,
      File? image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee,
      List<Cuisine> cuisines) async {
    Uri uri = Uri.parse(url.editRestaurant(restaurant.id));

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);

    String cus = '';
    for (var element in cuisines) {
      cus += element.id + ',';
    }

    cus = cus.substring(0, cus.length - 1);

    // Map<String, dynamic> deliveryFeeMap = {};
    // for (var element in emiratesDeliveryFee) {
    //   deliveryFeeMap[element.emirateName.toLowerCase().replaceAll(' ', '_')] =
    //       element.deliveryFee.text;
    // }

    // List<String> deliveryCitiesMap = [];
    // for (var element in emiratesDeliveryFee) {
    //   deliveryCitiesMap.add(element.englishName);
    // }

    // Map<String, String> deliveryCities = {};
    // for (var i = 0; i < deliveryCitiesMap.length; i++) {
    //   deliveryCities['$i'] = deliveryCitiesMap[i];
    // }
    Map<String, dynamic> mapJson = {
      "name": restaurant.name,
      "name_arb": restaurant.nameArb,
      "description": restaurant.description,
      "description_arb": restaurant.descriptionArb,
      'address': restaurant.address,
      'arb_address': restaurant.addressArb,
      'latitude': restaurant.latitude,
      'longitude': restaurant.longitude,
      'phone': restaurant.phone,
      'mobile': restaurant.mobile,
      'admin_commission': 0.0,
      'cuisines': cus,
      '_method': 'PUT',
      // 'delivery_fee': deliveryFeeMap,
      // 'delivery_cities': deliveryCities,
      'default_tax': restaurant.defaultTax,
      'delivery_range': '0',
      // 'available_for_delivery': restaurant.availableForDelivery?1:0,
      'available_for_delivery': 1,
      'closed': restaurant.closed,
      'information': restaurant.information,
      'active': 0,
      'avg_time': restaurant.avgTime,
    };

    if (image != null) {
      String fileName = image.path.split('/').last;
      mapJson['image'] =
          await MultipartFile.fromFile(image.path, filename: fileName);
    }
    // if (deliveryCitiesMap.isNotEmpty) {
    //   mapJson['delivery_fee'] = deliveryFeeMap;
    //   mapJson['delivery_cities'] = deliveryCities;
    // }
    FormData formData = FormData.fromMap(mapJson);

    try {
      final response = await dio.postUri(uri, data: formData);
      print(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('second_screen_details');
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> setCloseRestaurant(String restaurantId, bool isClosed) async {
    Uri uri = Uri.parse(url.editRestaurant(restaurantId));

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;

    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.putUri(uri, data: {
        'closed': isClosed,
      });
      return response.data['success'] ?? false;
    } catch (e) {
      final response = e as DioError;
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<List<Food>> getFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/foods/categories');
    Map<String, dynamic> query = {
      'with': 'restaurant;category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId',
      'searchFields': 'restaurant_id:=',
      'api_token': authViewModel.user!.apiToken,
    };

    uri = uri.replace(queryParameters: query);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Food>((json) => Food.fromJSON(json))
        .toList();
  }
}

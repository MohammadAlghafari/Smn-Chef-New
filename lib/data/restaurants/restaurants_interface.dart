import 'dart:io';

import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/order/model/category.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/order/model/review.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';

import 'model/gallery.dart';

abstract class RestaurantsInterface {
  Future<List<Restaurant>> getRestaurants();

  Future<Restaurant> getRestaurant(String id);

  Future<List<Review>> getRestaurantReviews(String id);

  Future<List<Gallery>> getGalleries(String idRestaurant);

  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId);

  Future<List<Cuisine>> getCuisines();

  Future<List<Category>> getCategories();

  Future<bool> createFood(
      {required File image, required Food food, required String restaurantId});

  Future<bool> editFood(
      {required File? image, required Food food, required String restaurantId});

  Future<bool> createRestaurant(Restaurant restaurant, File image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee, List<Cuisine> cuisines);

  Future<bool> editRestaurant(Restaurant restaurant, File? image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee, List<Cuisine> cuisines);

  Future<List<Food>> getFoodsOfRestaurant(String idRestaurant);

  Future<bool> setCloseRestaurant(String restaurantId, bool isClosed);
  Future<bool>  deleteFood(String foodId);
}

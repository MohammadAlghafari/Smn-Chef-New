import 'dart:io';

import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/order/model/category.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/order/model/review.dart';
import 'package:smn_admin/data/restaurants/model/gallery.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/data/restaurants/restaurants_interface.dart';

import 'api/restaurants_api.dart';

class RestaurantsRepo implements RestaurantsInterface {
  RestaurantsApi restaurantsApi;

  RestaurantsRepo({required this.restaurantsApi});

  @override
  Future<List<Restaurant>> getRestaurants() {
    return restaurantsApi.getRestaurants();
  }

  @override
  Future<Restaurant> getRestaurant(String id) {
    return restaurantsApi.getRestaurant(id);
  }

  @override
  Future<List<Review>> getRestaurantReviews(String id) {
    return restaurantsApi.getRestaurantReviews(id);
  }

  @override
  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) {
    return restaurantsApi.getFeaturedFoodsOfRestaurant(restaurantId);
  }

  @override
  Future<List<Gallery>> getGalleries(String idRestaurant) {
    return restaurantsApi.getGalleries(idRestaurant);
  }

  @override
  Future<List<Cuisine>> getCuisines() async {
    return restaurantsApi.getCuisines();
  }

  @override
  Future<List<Category>> getCategories() async {
    return restaurantsApi.getCategories();
  }

  @override
  Future<bool> createFood(
      {required File image, required Food food, required String restaurantId}) {
    return restaurantsApi.createFood(
        image: image, food: food, restaurantId: restaurantId);
  }

  @override
  Future<bool> editFood(
      {required File? image,
      required Food food,
      required String restaurantId}) {
    return restaurantsApi.editFood(
        image: image, food: food, restaurantId: restaurantId);
  }

  @override
  Future<bool> createRestaurant(Restaurant restaurant, File image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee, List<Cuisine> cuisines) {
    return restaurantsApi.createRestaurant(
        restaurant, image, emiratesDeliveryFee, cuisines);
  }

  @override
  Future<bool> editRestaurant(Restaurant restaurant, File? image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee, List<Cuisine> cuisines) {
    return restaurantsApi.editRestaurant(
        restaurant, image, emiratesDeliveryFee, cuisines);
  }

  @override
  Future<List<Food>> getFoodsOfRestaurant(String idRestaurant) async {
    return restaurantsApi.getFoodsOfRestaurant(idRestaurant);
  }

  @override
  Future<bool> setCloseRestaurant(String restaurantId, bool isClosed){
    return restaurantsApi.setCloseRestaurant(restaurantId, isClosed);
  }

  @override
  Future<bool>  deleteFood(String foodId) {
    return restaurantsApi.deleteFood(foodId);
  }
}

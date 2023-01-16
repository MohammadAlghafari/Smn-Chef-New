import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/emirates_delivery_fee.dart';
import 'package:smn_admin/data/order/model/address.dart';
import 'package:smn_admin/data/order/model/category.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/order/model/review.dart';
import 'package:smn_admin/data/restaurants/model/gallery.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/data/restaurants/restaurents_repo.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';


class RestaurantsViewModel extends ChangeNotifier {
  SettingViewModel settingViewModel;
  bool loadingDataRestaurants = true;
  bool loadingFeaturedFoods = true;
  bool loadingFoods = true;
  bool loadingReviews = true;
  bool loadingGalleries = true;
  bool loadingRestaurant = true;
  Restaurant? restaurant;
  RestaurantsRepo restaurantsRepo;
  List<Restaurant> restaurants = <Restaurant>[];
  List<Food> featuredFoods = <Food>[];
  List<Food> foods = <Food>[];
  List<Gallery> galleries = <Gallery>[];
  List<Review> reviews = <Review>[];
  List<Cuisine> cuisines = [];
  List<Category> categories = [];

  RestaurantsViewModel(
      {required this.restaurantsRepo, required this.settingViewModel}) {
    getCategories();
    getCuisines();
  }

  void listenForRestaurants({String? message}) async {
    restaurants.clear();
    loadingDataRestaurants = true;
    restaurants = await restaurantsRepo.getRestaurants();
    loadingDataRestaurants = false;
    notifyListeners();
  }

  Future<void> refreshRestaurants() async {
    restaurants.clear();
    listenForRestaurants(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .restaurant_refreshed_successfuly);
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant!.id;
    restaurant = Restaurant.fromJSON({});
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    foods.clear();
    listenForRestaurant(
        id: _id,
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFoods(_id);
    listenForFeaturedFoods(_id);
  }

  void listenForRestaurant({required String id, String? message}) async {
    restaurant = await restaurantsRepo.getRestaurant(id);
    loadingRestaurant = false;
    notify();
  }

  void listenForGalleries(String idRestaurant) async {
    galleries = [];

    galleries = await restaurantsRepo.getGalleries(idRestaurant);
    loadingGalleries = false;
    notify();
  }

  void listenForRestaurantReviews({required String id, String? message}) async {
    reviews = await restaurantsRepo.getRestaurantReviews(id);
    loadingReviews = false;
    notify();
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    featuredFoods = [];
    featuredFoods =
        await restaurantsRepo.getFeaturedFoodsOfRestaurant(idRestaurant);
    loadingFeaturedFoods = false;
    notify();
  }

  void listenForFoods(String idRestaurant) async {
    foods = [];
    foods = await restaurantsRepo.getFoodsOfRestaurant(idRestaurant);
    loadingFoods = false;
    notify();
  }

  void init(String id) {
    featuredFoods.clear();
    restaurant = null;
    galleries.clear();
    reviews.clear();
    loadingReviews = true;
    loadingFeaturedFoods = true;
    loadingGalleries = true;
    loadingRestaurant = true;
    loadingFoods = true;
    listenForRestaurant(id: id);
    listenForFoods(id);
    listenForGalleries(id);
    listenForFeaturedFoods(id);
    listenForRestaurantReviews(id: id);
  }

  void notify() {
    if (!(loadingReviews ||
        loadingFeaturedFoods ||
        loadingGalleries ||
        loadingRestaurant ||
        loadingFoods)) notifyListeners();
  }

  bool isLoadingRestaurant() {
    return loadingReviews ||
        loadingFeaturedFoods ||
        loadingGalleries ||
        loadingRestaurant;
  }

  ///Map
  Completer<GoogleMapController> mapController = Completer();
  List<Marker> allMarkers = <Marker>[];
  Address? currentAddress;
  CameraPosition? cameraPosition;

  void getRestaurantLocation() async {
    allMarkers.clear();
    try {
      cameraPosition = CameraPosition(
        target: LatLng(double.parse(restaurant!.latitude),
            double.parse(restaurant!.longitude)),
        zoom: 12.4746,
      );
      Helper.getRestaurantPositionMarker(double.parse(restaurant!.latitude),
              double.parse(restaurant!.longitude))
          .then((marker) {
        allMarkers.add(marker);
        notifyListeners();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
    // notifyListeners();
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    settingViewModel.setCurrentLocation().then((_currentAddress) {
      if (_currentAddress == null || _currentAddress.address == null) return;
      settingViewModel.myAddress = _currentAddress;
      currentAddress = _currentAddress;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentAddress.latitude, _currentAddress.longitude),
        zoom: 14.4746,
      )));
    });
  }

  void getCurrentLocation() async {
    try {
      currentAddress = settingViewModel.myAddress;
      if (currentAddress == null) {
        cameraPosition = CameraPosition(
          target: LatLng(40, 3),
          zoom: 4,
        );
      } else {
        cameraPosition = CameraPosition(
          target: LatLng(currentAddress!.latitude, currentAddress!.longitude),
          zoom: 12.4746,
        );
      }
      if (currentAddress != null) {
        Helper.getMyPositionMarker(
                currentAddress!.latitude, currentAddress!.longitude)
            .then((marker) {
          allMarkers.add(marker);
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
    // notifyListeners();
  }

  ///get cuisines
  Future<void> getCuisines() async {
    cuisines = await restaurantsRepo.getCuisines();
    notifyListeners();
  }

  Future<bool> createRestaurant(
      Restaurant restaurant,
      File? image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee,
      List<Cuisine> cuisines,
      BuildContext context) async {
    if (image == null) {
      showToast(
          context: context,
          message: AppLocalizations.of(context)!.please_upload_an_image);
      return false;
    }
    if (await restaurantsRepo.createRestaurant(
        restaurant, image, emiratesDeliveryFee, cuisines)) {
      // showToast(
      //     context: context,
      //     message:
      //         AppLocalizations.of(context)!.restaurant_create_successfully);
      Navigator.pushNamedAndRemoveUntil(
        context,
        'WaiteUnActiveRestaurantScreen',
        (route) => false,
      );

      return true;
    }
    return false;
  }

  Future<bool> editRestaurant(
      Restaurant restaurant,
      File? image,
      List<EmiratesDeliveryFee> emiratesDeliveryFee,
      List<Cuisine> cuisines,
      BuildContext context) async {
    if (await restaurantsRepo.editRestaurant(
        restaurant, image, emiratesDeliveryFee, cuisines)) {
      showToast(
          context: context,
          message:
              AppLocalizations.of(context)!.restaurant_updated_successfully);
      // refreshRestaurant();
      // Navigator.popUntil(context,
      //         (route) => route.settings.name == 'RestaurantsDetailsScreen');
      Provider.of<AuthViewModel>(context,listen: false).checkExistRestaurant();


      return true;
    }
    return false;
  }

  Future<void> getCategories() async {
    categories = await restaurantsRepo.getCategories();
    notifyListeners();
  }

  /// Food
  Future<void> createFood({required File image, required Food food}) async {
    if (await restaurantsRepo.createFood(
        image: image, food: food, restaurantId: restaurant!.id)) {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .food_created_successfully));
      listenForFeaturedFoods(restaurant!.id);
      listenForFoods(restaurant!.id);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    }
  }

  Future<void> editFood({File? image, required Food food}) async {
    if (await restaurantsRepo.editFood(
        image: image, food: food, restaurantId: restaurant!.id)) {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .food_updated_successfully));
      listenForFeaturedFoods(restaurant!.id);
      listenForFoods(restaurant!.id);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    }
  }

  Future<void> deleteFood({required String foodId}) async {
    if (await restaurantsRepo.deleteFood(foodId)) {
      listenForFeaturedFoods(restaurant!.id);
      listenForFoods(restaurant!.id);
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .food_deleted_successfully));
    }
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  }

  void setCloseRestaurant(String restaurantId, bool isClosed) async {
    if (await restaurantsRepo.setCloseRestaurant(restaurant!.id, isClosed)) {
      refreshRestaurant();
      if (isClosed) {
        showSnackBar(
            message: (AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .kitchen_closed_successfully));
      } else {
        showSnackBar(
            message: (AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .kitchen_open_successfully));
      }
    }
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  }
}

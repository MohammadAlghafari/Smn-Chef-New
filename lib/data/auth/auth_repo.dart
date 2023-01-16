import 'dart:io';

import 'package:smn_admin/data/auth/api/auth_api.dart';
import 'package:smn_admin/data/auth/auth_interfce.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';

import 'model/emirates_delivery_fee.dart';

class AuthRepo implements AuthInterface {
  AuthApi authApi;

  AuthRepo({required this.authApi}) {}

  @override
  Future<User?> login(String email, String password) async {
    return await authApi.login(email, password);
  }

  @override
  Future<bool> resetPassword(String email) {
    return authApi.resetPassword(email);
  }

  @override
  Future<bool> deleteAccount( String apiToken) {
    return authApi.deleteAccount(apiToken);
  }

  @override
  Future<Map<String, dynamic>> checkExistRestaurant(
      String userId, String apiToken) async {
    return authApi.checkExistRestaurant(userId, apiToken);
  }

  @override
  Future<Map<String, dynamic>> checkRegister(Map<String,dynamic>body) async {
    return await authApi.checkRegister(body);
  }

  @override
  Future<User> register(Map<String,dynamic>body) async{
    return authApi.register(body);
  }

  @override
  Future<bool> sendOTP(String number) {
    return authApi.sendOTP(number);
  }

  @override
  Future<bool> verifyOTP(String phone, String code) {
    return authApi.verifyOTP(phone, code);
  }
}

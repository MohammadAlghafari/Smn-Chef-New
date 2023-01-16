import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart';

import '../../../smn_chef.dart';

class AuthApi {
  Dio dio;

  AuthApi({required this.dio});

  Future<User?> login(String email, String password) async {
    try {
      final response = await dio.post(url.login(), data: {
        "email": email,
        "password": password,
        'device_token': await getDeviceToken()
      });
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        return User.fromJSON(response.data['data']);
      } else {
        showSnackBar(
            message: (AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .wrong_email_or_password));
        return null;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      final response =
          await dio.post(url.resetPassword(), data: {"email": email});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> sendOTP(String number) async {
    try {
      final response =
          await dio.post(url.sendOTP(), data: {"phone": number});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }
  

  Future<bool> verifyOTP(String phone, String code) async {
    try {
      final response =
          await dio.post(url.verifyOTP(), data: {"token": code, "phone": phone});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> deleteAccount(String apiToken) async {
    try {
      Map<String, dynamic> _queryParams = {};
      _queryParams['api_token'] = apiToken;
      Uri uri = Uri.parse(url.deleteAccount());
      uri = uri.replace(queryParameters: _queryParams);
      final response = await dio.deleteUri(
        uri,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<String> getDeviceToken() async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    return token;
  }

  Future<Map<String, dynamic>> checkExistRestaurant(
      String userId, String apiToken) async {
    Uri uri = Uri.parse(url.checkExistRestaurant());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = apiToken;

    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.postUri(uri, data: {
        "user_id": userId,
      });

      return response.data;
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> checkRegister(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url.checkRegister());
    final response = await dio.postUri(uri, data: body);

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      return response.data;
    } else {
      throw Exception(response.data);
    }
  }

  Future<User> register(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url.register());
    // final String url = '${GlobalConfiguration().getValue('api_base_url')}register';
    try {
      final response = await dio.postUri(uri, data: body);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        setCurrentUser(response.data['data']);

        return User.fromJSON(response.data['data']);
      }
      return User.fromJSON({});
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return User.fromJSON({});
    }
  }

  void setCurrentUser(jsonString) async {
    jsonString['device_token'] = await getDeviceToken();
    try {
      if (jsonString['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user', json.encode(jsonString['data']));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

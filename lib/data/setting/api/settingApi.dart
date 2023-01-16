import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/setting/model/setting.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';

import '../../../smn_chef.dart';

class SettingApi {
  AuthViewModel authViewModel;
  Dio dio;

  SettingApi({required this.authViewModel, required this.dio});

  Future<Setting> getSetting() async {
    Uri uri = Uri.parse(await url.setting());

    try {
      final response = await dio.getUri(uri);
      if (response.statusCode != HttpStatus.ok) {
        return Setting.fromJSON({});
      }
      return Setting.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Setting.fromJSON({});
    }
  }

  Future<User> update(User user) async {
    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}';
    Uri uri = Uri.parse(url.updateSettings(authViewModel.user!.id!, _apiToken));

    try {
      final response = await dio.postUri(uri, data: user.toMap());
      setCurrentUser(response.data);
      authViewModel.updateUser(User.fromJSON(response.data['data']));
      return authViewModel.user!;
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return User.fromJSON({});
    }
  }

  void setCurrentUser(jsonString) async {
    try {
      if (jsonString['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user', json.encode(jsonString['data']));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    Uri uri = Uri.parse(url.changeUserLanguage());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user != null ? authViewModel.user!.apiToken : ' ';

    uri = uri.replace(queryParameters: _queryParams);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('language', languageCode);

    try {
      final response = await dio.postUri(uri, data: {
        "language": languageCode,
      });
      print(response.data);
      return;
    } catch (e) {
      print(e.toString());

      return;
    }
  }
}

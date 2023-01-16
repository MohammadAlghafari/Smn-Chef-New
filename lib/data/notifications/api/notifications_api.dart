import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/notifications/model/notification.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

import '../../../smn_chef.dart';

class NotificationsApi {
  AuthViewModel authViewModel;
  SettingViewModel settingViewModel;
  Dio dio;

  NotificationsApi(
      {required this.authViewModel,
      required this.settingViewModel,
      required this.dio});

  Future<List<Notification>> getNotifications() async {
    Uri uri = Helper.getUri('api/notifications');
    Map<String, dynamic> _queryParams = {};
    User _user = authViewModel.user!;
    //print('uri' + '$uri');
    if (_user.apiToken == null) {
      return [];
    }
    _queryParams['api_token'] = _user.apiToken;
    _queryParams['search'] = 'notifiable_id:${_user.id}';
    _queryParams['searchFields'] = 'notifiable_id:=';
    _queryParams['orderBy'] = 'created_at';
    _queryParams['sortedBy'] = 'desc';
    _queryParams['limit'] = '10';
    uri = uri.replace(queryParameters: _queryParams);
    if (_user.id == null) return [];
    try {
      final response = await dio.getUri(uri);
      if (response.statusCode != 200) return [];
      return (response.data as List)
          .map<Notification>((json) => Notification.fromJSON(json))
          .toList();
    } catch (e) {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .error_get_notifications));
      return [];
    }
  }

  Future<Notification> markAsReadNotifications(
      Notification notification) async {
    User _user = authViewModel.user!;

    if (_user.apiToken == null) {
      return Notification.fromJSON({});
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    try {
      final response = await dio.putUri(
          Uri.parse(url.markAsReadNotifications(notification.id, _apiToken)),
          data: notification.markReadMap());

      return Notification.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Notification.fromJSON({});
    }
  }

  Future<Notification> removeNotification(Notification cart) async {
    User _user = authViewModel.user!;

    if (_user.apiToken == null) {
      return Notification.fromJSON({});
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    try {
      final response = await dio.deleteUri(
        Uri.parse(url.removeNotification(cart.id, _apiToken)),
      );
      return Notification.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Notification.fromJSON({});
    }
  }

  Future<void> sendNotification(String body, String title, User user) async {
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "messages",
        "status": "done"
      },
      "to": "${user.deviceToken}"
    };
    print('user.deviceToken');
    print(user.deviceToken);
    print(user.email);
    //chef
    //dLScLdX9S1-4-yC71Dv3DN:APA91bFOBJu6nIiSN75j36rD-2R1iYqXtRmu3zmKeHPEfPlrcHzW5uIByJG5lFH1Zw3FGSI1ERVg4o0FIDa5MMD2YMDLcyPbAFxJxSnujfcDh3oHha9-RMnNk5qTJZkcJtZ_BvosJE67


    // final client = http.Client();
    // final response = await client.post(
    //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //   headers: {
    //     HttpHeaders.contentTypeHeader: 'application/json',
    //     HttpHeaders.authorizationHeader:
    //         "key=${settingViewModel.setting.fcmKey}",
    //   },
    //   body: json.encode(data),
    // );
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "key=${settingViewModel.setting.fcmKey}";
    try {
      final response = await dio.postUri(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        data: data,
      );
      print(response.data);
      print(response.statusCode);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return ;
    }
  }
}

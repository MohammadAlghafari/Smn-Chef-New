import 'package:smn_admin/data/auth/api/auth_api.dart';
import 'package:smn_admin/data/auth/auth_interfce.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/setting/api/settingApi.dart';
import 'package:smn_admin/data/setting/model/setting.dart';
import 'package:smn_admin/data/setting/setting_interface.dart';

class SettingRepo implements SettingInterface {
  SettingApi settingApi;

  SettingRepo({required this.settingApi}) {}

  @override
  Future<Setting> getSetting() async {
    return await settingApi.getSetting();
  }

  @override
  Future<User> update(User user)async{
    return settingApi.update(user);
  }

  @override
  Future<void> changeLanguage(String languageCode)async {
    return await settingApi.changeLanguage(languageCode);
  }
}

import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/setting/model/setting.dart';

abstract class SettingInterface {
  Future<Setting> getSetting();
  Future<User> update(User user);
  Future<void> changeLanguage(String languageCode);
}

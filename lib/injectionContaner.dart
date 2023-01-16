import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/data/auth/api/auth_api.dart';
import 'package:smn_admin/data/auth/auth_repo.dart';
import 'package:smn_admin/data/faq/api/faq_api.dart';
import 'package:smn_admin/data/faq/fac_repo.dart';
import 'package:smn_admin/data/messages/api/messages_api.dart';
import 'package:smn_admin/data/messages/messages_repo.dart';
import 'package:smn_admin/data/notifications/api/notifications_api.dart';
import 'package:smn_admin/data/notifications/notifications_repo.dart';
import 'package:smn_admin/data/order/api/order_api.dart';
import 'package:smn_admin/data/order/order_repo.dart';
import 'package:smn_admin/data/restaurants/api/restaurants_api.dart';
import 'package:smn_admin/data/restaurants/restaurents_repo.dart';
import 'package:smn_admin/data/setting/api/settingApi.dart';
import 'package:smn_admin/data/setting/setting_repo.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/faq_veiw_model.dart';
import 'package:smn_admin/view_models/messages_view_model.dart';
import 'package:smn_admin/view_models/notifications_view_model.dart';
import 'package:smn_admin/view_models/order_view_model.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';


final si = GetIt.instance;

Future<void> init() async {
  /// Core
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('language')) {
    prefs.setString('language', 'en');
  }
  si.registerLazySingleton(() => prefs);
  Dio dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (prefs.containsKey('language')) {
        options.headers['language'] = prefs.getString('language');
      }
      handler.next(options);
    },
  ));
  dio.options.headers['content-Type'] = 'application/json';
  si.registerLazySingleton(() => dio);



  /// Provider
  si.registerLazySingleton(() => AuthViewModel(authRepo: si(), prefs: si()));

  si.registerLazySingleton(
      () => SettingViewModel(settingRepo: si(), prefs: si(), authViewModel: si()));
  si.registerLazySingleton(
      () => OrderViewModel(orderRepo: si(), authViewModel: si()));
  si.registerLazySingleton(() =>
      RestaurantsViewModel(restaurantsRepo: si(), settingViewModel: si()));
  si.registerLazySingleton(() => MessagesViewModel(
      messagesRepo: si(), authViewModel: si(), notificationsViewModel: si()));
  si.registerLazySingleton(
      () => NotificationsViewModel(notificationsRepo: si()));
  si.registerLazySingleton(() => FaqViewModel(faqRepo: si()));

  /// Repos
  si.registerLazySingleton(() => AuthRepo(authApi: si()));
  si.registerLazySingleton(() => SettingRepo(settingApi: si()));
  si.registerLazySingleton(() => OrderRepo(orderApi: si()));
  si.registerLazySingleton(() => RestaurantsRepo(restaurantsApi: si()));
  si.registerLazySingleton(() => MessagesRepo(messagesApi: si()));
  si.registerLazySingleton(() => NotificationsRepo(notificationsApi: si()));
  si.registerLazySingleton(() => FaqRepo(faqApi: si()));

  /// APIs Call
  si.registerLazySingleton(() => AuthApi(dio: si()));
  si.registerLazySingleton(() => SettingApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => OrderApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(
      () => RestaurantsApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => MessagesApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() =>
      NotificationsApi(settingViewModel: si(), authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => FaqApi(authViewModel: si(), dio: si()));
}

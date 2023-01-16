import 'package:shared_preferences/shared_preferences.dart';

String get api_base_url {
  return 'https://staging.smnfood.app/api/manager';
  // return 'https://smnfood.app/api/manager';
}

String get baseUrl {
  return 'https://staging.smnfood.app/';
  // return 'https://smnfood.app/';
}

String get api_base_url_customer {
  return 'https://staging.smnfood.app/api/';
  // return 'https://smnfood.app/api/';
}

// String? lang;
Future<String> lang() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString("language_code") == null) return "en";
  return prefs.getString("language_code") ?? "en";
}

String login() {
  return "$api_base_url/login";
}

String resetPassword() {
  return "$api_base_url/send_reset_link_email";
}

String sendOTP() {
  return "${api_base_url_customer}send-otp";
}

String verifyOTP() {
  return "${api_base_url_customer}check-otp";
}

String deleteAccount() {
  return "${api_base_url_customer}delete_account";
}

Future<String> setting() async {
  return "$api_base_url/settings";
}

String getStatistics(String id) {
  return "${baseUrl}api/manager/dashboard/$id";
}

String getOrders() {
  return "$api_base_url/api/orders";
}

String cancelOrder(String id) {
  return "$api_base_url/api/orders/$id";
}

String orderStatuses() {
  return "${baseUrl}api/order_statuses";
}

String markAsReadNotifications(String notificationsId, String apiToken) {
  return '${api_base_url_customer}notifications/$notificationsId?$apiToken';
}

String removeNotification(String cartId, String apiToken) {
  return '${api_base_url_customer}notifications/$cartId?$apiToken';
}

String updateSettings(String userId, String apiToken) {
  return '$api_base_url/users/$userId?$apiToken';
}

String getFaqCategories(String apiToken) {
  return '$api_base_url/faq_categories?${apiToken}with=faqs';
}

String checkExistRestaurant() {
  return '${api_base_url_customer}userRestaurant';
}

String createRestaurant() {
  return '${api_base_url}/restaurants';
}

String editRestaurant(String id) {
  return '${api_base_url}/restaurants/$id';
}

String getCuisines() {
  return '${api_base_url_customer}cuisines';
}

String changeUserLanguage() {
  return '${api_base_url_customer}language';
}

String getCategories() {
  return '${api_base_url_customer}categories';
}

String createFood() {
  return '${api_base_url}/foods';
}

String editFood(String foodId) {
  return '${api_base_url}/foods/$foodId';
}

String deleteFood(String foodId) {
  return '${api_base_url}/foods/$foodId';
}

String checkRegister() {
  return '${api_base_url_customer}check-register';
}

String register() {
  return '${api_base_url}/register';
}

String createChat() {
  return '${api_base_url_customer}chat_create';
}

String sendChat() {
  return '${api_base_url_customer}message_create';
}

import 'package:flutter/material.dart';

class Setting {
  String appName = '';
  String day = '';
  double defaultTax;
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  int currencyDecimalDigits = 2;
  bool payPalEnabled = true;
  bool stripeEnabled = true;
  bool razorPayEnabled = true;
  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;
  String googleMapsKey;
  String fcmKey;
  Locale mobileLanguage = Locale('en', '');
  String appVersion;
  bool enableVersion = true;
  Brightness brightness = Brightness.light;

  factory Setting.init() {
    return Setting(
        appName: "appName",
        day: "1",
        defaultTax: 0.0,
        defaultCurrency: "AED",
        distanceUnit: "1",
        currencyRight: false,
        currencyDecimalDigits: 1,
        payPalEnabled: false,
        stripeEnabled: false,
        razorPayEnabled: false,
        mainColor: "000",
        mainDarkColor: "000",
        secondColor: "000",
        secondDarkColor: "000",
        accentColor: "000",
        accentDarkColor: "000",
        scaffoldDarkColor: "000",
        scaffoldColor: "000",
        googleMapsKey: "000",
        fcmKey: "",
        mobileLanguage: Locale('en'),
        appVersion: "1.0.0",
        enableVersion: false);
  }

  Setting({
    required this.appName,
    required this.day,
    required this.defaultTax,
    required this.defaultCurrency,
    required this.distanceUnit,
    required this.currencyRight,
    required this.currencyDecimalDigits,
    required this.payPalEnabled,
    required this.stripeEnabled,
    required this.razorPayEnabled,
    required this.mainColor,
    required this.mainDarkColor,
    required this.secondColor,
    required this.secondDarkColor,
    required this.accentColor,
    required this.accentDarkColor,
    required this.scaffoldDarkColor,
    required this.scaffoldColor,
    required this.googleMapsKey,
    required this.fcmKey,
    required this.mobileLanguage,
    required this.appVersion,
    required this.enableVersion,
  });

  factory Setting.fromJSON(Map<String, dynamic> jsonMap) {
    return Setting(
      appName: jsonMap['app_name'] ?? ' ',
      day: jsonMap['day'] ?? "",
      mainColor: jsonMap['main_color'] ?? ' ',
      mainDarkColor: jsonMap['main_dark_color'] ?? '',
      secondColor: jsonMap['second_color'] ?? '',
      secondDarkColor: jsonMap['second_dark_color'] ?? '',
      accentColor: jsonMap['accent_color'] ?? '',
      accentDarkColor: jsonMap['accent_dark_color'] ?? '',
      scaffoldDarkColor: jsonMap['scaffold_dark_color'] ?? '',
      scaffoldColor: jsonMap['scaffold_color'] ?? '',
      googleMapsKey: jsonMap['google_maps_key'] ?? null,
      fcmKey: jsonMap['fcm_key'] ?? null,
      mobileLanguage: Locale(jsonMap['mobile_language'] ?? "en", ''),
      appVersion: jsonMap['app_version'] ?? '',
      distanceUnit: jsonMap['distance_unit'] ?? 'km',
      enableVersion:
          jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0'
              ? false
              : true,
      defaultTax: double.tryParse(jsonMap['default_tax']) ?? 0.0,
      defaultCurrency: jsonMap['default_currency'] ?? '',
      currencyDecimalDigits:
          int.tryParse(jsonMap['default_currency_decimal_digits']) ?? 2,
      currencyRight:
          jsonMap['currency_right'] == null || jsonMap['currency_right'] == '0'
              ? false
              : true,
      payPalEnabled:
          jsonMap['enable_paypal'] == null || jsonMap['enable_paypal'] == '0'
              ? false
              : true,
      stripeEnabled:
          jsonMap['enable_stripe'] == null || jsonMap['enable_stripe'] == '0'
              ? false
              : true,
      razorPayEnabled: jsonMap['enable_razorpay'] == null ||
              jsonMap['enable_razorpay'] == '0'
          ? false
          : true,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_name"] = appName;
    map["day"] = day;
    map["default_tax"] = defaultTax;
    map["default_currency"] = defaultCurrency;
    map["default_currency_decimal_digits"] = currencyDecimalDigits;
    map["currency_right"] = currencyRight;
    map["enable_paypal"] = payPalEnabled;
    map["enable_stripe"] = stripeEnabled;
    map["enable_razorpay"] = razorPayEnabled;
    map["mobile_language"] = mobileLanguage.languageCode;
    return map;
  }
}

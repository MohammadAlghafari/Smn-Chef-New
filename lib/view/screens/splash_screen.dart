import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = const Duration(milliseconds: 4000);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString("language_code") == null) {
    //   prefs.setString("language_code", "en");
    // }
    // Provider.of<AppLanguage>(context, listen: false)
    //     .changeLanguage(Locale(prefs.getString("language_code")??"en"));
    // prefs.clear();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        await Provider.of<SettingViewModel>(context,listen: false).loadSettings();

      }
    } on SocketException catch (_) {
      print('not connected');
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.verify_your_internet_connection,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: myColors.deepOrange,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0
      );
      // Navigator.pushReplacementNamed(
      //     context, '/',);
      Timer(Duration(milliseconds: 4000), navigationPage);
      return;
    }

    ///Check internet connection
    if (await Helper.isNotInternetConnected()) {
      showToast(
          context: context,
          seconds: 5,
          message:
              AppLocalizations.of(context)!.verify_your_internet_connection);
    } else {
      /// check if the user login
      if (await Provider.of<AuthViewModel>(context, listen: false).isAuth()) {
        // Navigator.pushReplacementNamed(context, 'HomeScreen', arguments: 2);
        ///check if the user has restaurant
        await Provider.of<AuthViewModel>(context, listen: false)
            .checkExistRestaurant();
      } else {
        Navigator.pushReplacementNamed(context, 'LoginScreen');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // key: _con.scaffoldKey,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo_animation.gif',
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              //LoadingProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}


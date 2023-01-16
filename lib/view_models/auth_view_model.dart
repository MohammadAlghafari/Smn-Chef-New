import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/auth_repo.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view/screens/settings/mobile_verification_bottom_sheet_widget.dart';

class AuthViewModel extends ChangeNotifier {
  AuthRepo authRepo;
  User? user;
  SharedPreferences prefs;
  late OverlayEntry loader;

  AuthViewModel({required this.authRepo, required this.prefs}) {
    loadUserFromShared();
  }

  loadUserFromShared() async {
    if (prefs.getString("current_user") != null) {
      user = User.fromJSON(json.decode(prefs.getString("current_user")!));
    }
  }

  Future<bool> isAuth() async {
    return prefs.getBool("isLogin") == null ? false : prefs.getBool("isLogin")!;
  }

  login(String email, String password, BuildContext context) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = await authRepo.login(email, password);
    loader.remove();
    if (user != null) {
      prefs.setBool("isLogin", true);
      prefs.setString("current_user", json.encode(user!));

      /// after login check if my kitchen exist or not
      /// checkExistRestaurant
      checkExistRestaurant();
      // Navigator.pushReplacementNamed(context, 'HomeScreen', arguments: 2);
    }
    /*
     else {
      showToast(
          message: AppLocalizations.of(context)!.wrong_email_or_password,
          context: context,
          gravity: ToastGravity.CENTER);
    }
    * */
  }

  resetPassword(String email, BuildContext context) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    bool isLinkSent = await authRepo.resetPassword(email);
    loader.remove();
    if (isLinkSent) {
      prefs.setBool("isLogin", true);
      Navigator.pushReplacementNamed(context, 'LoginScreen');
      showToast(
          message: AppLocalizations.of(context)!
              .your_reset_link_has_been_sent_to_your_email,
          context: context,
          gravity: ToastGravity.CENTER);
    } else {
      showToast(
          message: AppLocalizations.of(context)!.error_verify_email_settings,
          context: context,
          gravity: ToastGravity.CENTER);
    }
  }

  void logout() {
    prefs.clear();
    Navigator.of(NavigationService.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(
            'LoginScreen', (Route<dynamic> route) => false);
  }

  deleteAccount(
    BuildContext context,
  ) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    await authRepo.deleteAccount(user!.apiToken!).then((value) {
      loader.remove();
      if (value) {
        prefs.setBool("isLogin", false);
        Navigator.of(context).pushNamedAndRemoveUntil(
            'LoginScreen', (Route<dynamic> route) => false);
      }
    });
  }

  updateUser(User user) {
    this.user = user;
    notifyListeners();
  }

  Future<bool> sendOTP(String phonrNumber) async {
    return await authRepo.sendOTP(phonrNumber);
  }

  Future<bool> verifyOTP(String phone, String code) async {
    return await authRepo.verifyOTP(phone, code);
  }

  checkExistRestaurant() async {
    final response =
        await authRepo.checkExistRestaurant(user!.id!, user!.apiToken!);
    //{success: true, data: {user_id: 1}, message: Success}
    print(response);
    if (response.isEmpty) {
      logout();
      return;
    }
    
    int hasRestaurant = int.parse(response['data']['has_kitchen'] ?? 0);
    // hasRestaurant=0;
    if (hasRestaurant == 0) {
      ///dose not has restaurant
      Navigator.pushReplacementNamed(
          NavigationService.navigatorKey.currentContext!,
          'IntroCreateRestaurantScreen',
          arguments: user!.name);
    } else if (hasRestaurant == 1) {
      ///has restaurant and not active
      Navigator.pushReplacementNamed(
          NavigationService.navigatorKey.currentContext!,
          'WaiteUnActiveRestaurantScreen');
    } else {
      ///has restaurant and active (hasRestaurant==2)
      Navigator.pushReplacementNamed(
          NavigationService.navigatorKey.currentContext!, 'HomeScreen',
          arguments: 2);
    }
  }

  Future<bool> checkRegister(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required BuildContext context,
      required Map<String, dynamic> body}) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = User.fromJSON(body);
    authRepo.checkRegister(body).then((value) async{
      if (value['data']['email'] == '1' && value['data']['phone'] == '1') {
        loader.remove();
        bool res=await sendOTP(body['phone']);
        if(!res){
          return false;
        }
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: MobileVerificationBottomSheetWidget(
                scaffoldKey: scaffoldKey,
                phone: body['phone'],
                user: user!,
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ).then((value) {
          if (value != null && value) register(body, context);
        });
      } else {
        loader.remove();
        scaffoldKey.currentState?.showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.email_or_phone_already_exist)));
        return false;
      }
    }).catchError((e) {
      loader.remove();
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(
                NavigationService.navigatorKey.currentState!.context)!
            .these_credentials_do_not_match_our_records),
      ));
    });
    return false;
  }

  void register(Map<String, dynamic> body, BuildContext context) async {
    FocusScope.of(context).unfocus();
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = await authRepo.register(body);
    loader.remove();
    Helper.hideLoader(loader);
    if (user!.id != 'null' && user != null && user!.apiToken != null) {
      // showToast(
      //     context: context,
      //     message: (AppLocalizations.of(
      //             NavigationService.navigatorKey.currentContext!)!
      //         .please_wait_for_activate_your_account));

      Navigator.pushReplacementNamed(
          NavigationService.navigatorKey.currentContext!, 'LoginScreen');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!.registration_successful),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Text(AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .please_wait_for_activate_your_account),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  AppLocalizations.of(
                          NavigationService.navigatorKey.currentContext!)!
                      .ok,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {

                  Navigator.of(context).pop();

                },
              ),
            ],
          );
        },
      );
    }

    // }).catchError((e) {
    // // scaffoldKey.currentState.showSnackBar(SnackBar(
    // //   content: Text(AppLocalizations.of(
    // //       NavigationService.navigatorKey.currentState!.context)!.thisAccountNotExist),
    // // ));
    // }).whenComplete(() {
    // });
  }
}

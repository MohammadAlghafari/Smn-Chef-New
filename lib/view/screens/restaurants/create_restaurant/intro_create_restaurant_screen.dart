import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

class IntroCreateRestaurantScreen extends StatefulWidget {
  String userName;

  IntroCreateRestaurantScreen({Key? key, required this.userName})
      : super(key: key);

  @override
  _IntroCreateRestaurantScreenState createState() =>
      _IntroCreateRestaurantScreenState();
}

class _IntroCreateRestaurantScreenState
    extends State<IntroCreateRestaurantScreen> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: myColors.deepOrange,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/img/welcome.jpg',
                width: width,
              ),
              SizedBox(
                height: config.App().appHeight(1),
              ),
              Text(
                _trans.hi + ', ' + widget.userName,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: myColors.white),
              ),
              SizedBox(
                height: config.App().appHeight(1),
              ),
              Text(
                _trans.we_welcome_you,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: myColors.white),
              ),
              Text(
                _trans.create_your_kitchen_now,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: myColors.white),
              ),
              SizedBox(
                height: config.App().appHeight(5),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'CreateRestaurantScreen');
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Image.asset(
                  'assets/img/plus_icon.png',
                  height: config.App().appHeight(9),
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
            child: Directionality(

              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: myColors.orange,
                              width: 2.0,
                            ),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(myColors.orange)),
                    onPressed: () {
                      if (Provider.of<SettingViewModel>(context, listen: false)
                              .setting
                              .mobileLanguage
                              .languageCode ==
                          'en') {
                        Provider.of<SettingViewModel>(context, listen: false)
                            .changeLanguage('ar');
                      } else {
                        Provider.of<SettingViewModel>(context, listen: false)
                            .changeLanguage('en');
                      }
                    },
                    child: Text(
                        Provider.of<SettingViewModel>(context, listen: false)
                                    .setting
                                    .mobileLanguage
                                    .languageCode ==
                                'en'
                            ? 'العربية'
                            : 'English'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: myColors.orange,
                              width: 2.0,
                            ),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(myColors.orange)),
                    onPressed: () {
                      Provider.of<AuthViewModel>(context, listen: false)
                          .logout();
                    },
                    child: Text(_trans.log_out),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

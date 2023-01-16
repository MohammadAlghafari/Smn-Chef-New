import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/BlockButtonWidget.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';
import 'package:smn_admin/const/myColors.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();
  late AppLocalizations _trans;
  late bool hidePassword;
  final GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    hidePassword = true;
    super.initState();
  }

  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox(
              width: config.App().appWidth(100),
              height: 10000,
            ),
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: config.App().appHeight(37),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,

                      child: Container(
                        margin: EdgeInsets.only(
                          top: config.App().appHeight(15),
                          left: 35,
                          right: 35,
                          bottom: 20,
                        ),
                        child: Text(
                          _trans.lets_start_with_login,
                          style: Theme.of(context).textTheme.headline2!.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 50,
                              color: Theme.of(context).hintColor.withOpacity(0.2),
                            )
                          ]),
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 27),
                      width: config.App().appWidth(88),
                      //  height: config.App().appHeight(55),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Form(
                          key: loginFromKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailCont,
                                textInputAction: TextInputAction.next,
                                validator: (input) => !input!.contains('@')
                                    ? _trans.should_be_a_valid_email
                                    : null,
                                decoration: InputDecoration(
                                  labelText: _trans.email,
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600]),
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText: 'johndoe@gmail.com',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.alternate_email,
                                      color: Colors.grey[600]),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordCont,
                                validator: (v) {
                                  if (v!.length < 8) {
                                    return _trans.should_be_more_than_7_letters;
                                  }
                                  return null;
                                },
                                obscureText: hidePassword,
                                onFieldSubmitted: (v){
                                  if (loginFromKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    Provider.of<AuthViewModel>(context,
                                        listen: false)
                                        .login(emailCont.text, passwordCont.text,
                                        context);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: _trans.password,
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600]),
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText: '••••••••••••',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: Colors.grey[600]),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    color: Theme.of(context).focusColor,
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                ),
                              ),
                              const SizedBox(height: 30),
                              BlockButtonWidget(
                                text: Text(
                                  _trans.login,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (loginFromKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    Provider.of<AuthViewModel>(context,
                                            listen: false)
                                        .login(emailCont.text, passwordCont.text,
                                            context);
                                  }
                                },
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('ForgetPassword');
                            },
                            textColor: Theme.of(context).hintColor,
                            child: Text(_trans.i_forgot_password),
                          ),
                            FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('SignupScreen');
                            },
                            textColor: Theme.of(context).hintColor,
                            child: Text(_trans.i_dont_have_an_account),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton(
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/data/auth/model/user.dart' as um;
import 'package:smn_admin/view/screens/settings/mobile_verification_bottom_sheet_widget.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';

class ProfileNumberSettingsDialog extends StatefulWidget {
  final um.User user;
  final VoidCallback onChanged;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProfileNumberSettingsDialog(
      {Key? key,
      required this.user,
      required this.scaffoldKey,
      required this.onChanged})
      : super(key: key);

  @override
  _ProfileNumberSettingsDialogState createState() =>
      _ProfileNumberSettingsDialogState();
}

class _ProfileNumberSettingsDialogState
    extends State<ProfileNumberSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  String number = '';
  late AppLocalizations _trans;
  FocusNode phoneNode = FocusNode();
  CountryCode? countryCode = CountryCode(
      name: 'دولة الإمارات العربية المتحدة', code: 'AE', dialCode: '+971');


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      _trans.profile_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (input) {
                              if (input!.length < 9) {
                                return _trans.not_a_valid_phone;
                              }
                              return null;
                            },
                            focusNode: phoneNode,
                            maxLength: 9,
                            onChanged: (value) {
                              setState(() {
                                number = value;
                              });
                            },
                            initialValue: widget.user.phone!.replaceAll(countryCode!.dialCode!,''),
                            onSaved: (input) =>
                                widget.user.phone = countryCode!.dialCode! + input!,
                            decoration: InputDecoration(
                              counterText: '',
                              labelText: _trans.phoneNumber,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '53 624 6995',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: CountryCodePicker(
                                onChanged: (v) {
                                  countryCode = v;
                                },
                                boxDecoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor
                                ),
                                padding: EdgeInsets.zero,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'AE',
                                favorite: const ['+966', '+971'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(_trans.cancel),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (_profileSettingsFormKey.currentState!
                              .validate()) {
                            //TODO
                            if (countryCode!.dialCode!+ number != widget.user.phone && number != '') {
                              Navigator.of(context).pop();
                              widget.user.verifiedPhone = false;
                               bool res=await Provider.of<AuthViewModel>(context, listen: false)
                                  .sendOTP(countryCode!.dialCode!+ number);
                               if(!res)return;
                              var bottomSheetController = widget
                                  .scaffoldKey.currentState!
                                  .showBottomSheet(
                                (context) =>
                                    MobileVerificationBottomSheetWidget(
                                        scaffoldKey: widget.scaffoldKey,
                                        phone: countryCode!.dialCode!+ number,
                                        user: widget.user),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              );
                              bottomSheetController.closed.then((value) {
                                if (widget.user.verifiedPhone!) _submit();
                              });
                            } else {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text(
                          _trans.save,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        _trans.editNumber,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      counterText: '',
      hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    widget.user.phone =countryCode!.dialCode!+ number;

    widget.onChanged();
  }
}

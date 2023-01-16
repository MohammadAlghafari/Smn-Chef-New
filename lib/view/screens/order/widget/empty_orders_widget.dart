import 'dart:async';

import 'package:flutter/material.dart';

import 'package:smn_admin/utili/app_config.dart'as config;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyOrdersWidget extends StatefulWidget {
  EmptyOrdersWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyOrdersWidgetState createState() => _EmptyOrdersWidgetState();
}

class _EmptyOrdersWidgetState extends State<EmptyOrdersWidget> {
  bool loading = true;
  late AppLocalizations _trans;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: config.App().appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Theme.of(context).focusColor.withOpacity(0.7),
                          Theme.of(context).focusColor.withOpacity(0.05),
                        ])),
                    child: loading
                        ? Padding(
                      padding: const EdgeInsets.all(51),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    )
                        : Icon(
                      Icons.shopping_basket,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  _trans.you_dont_have_any_order_assigned_to_you,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.merge(const TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

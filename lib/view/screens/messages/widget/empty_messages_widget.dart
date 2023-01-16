import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/myColors.dart';

import 'package:smn_admin/utili/app_config.dart'as config;
class EmptyMessagesWidget extends StatefulWidget {
  EmptyMessagesWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyMessagesWidgetState createState() => _EmptyMessagesWidgetState();
}

class _EmptyMessagesWidgetState extends State<EmptyMessagesWidget> {
  bool loading = true;
  late AppLocalizations _trans;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
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
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
             color: Theme.of(context).colorScheme.secondary,
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App().appHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  _trans.youDontHaveAnyConversations,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),

            ],
          ),
        )
      ],
    );
  }
}

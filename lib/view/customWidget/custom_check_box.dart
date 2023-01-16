import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/myColors.dart';

class CustomCheckBox extends StatefulWidget {
  String title;
  Function onChange;

  CustomCheckBox({Key? key, required this.title, required this.onChange})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool closedKitchen = false;
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(color: myColors.deepOrange, fontSize: 18),
          ),
          Checkbox(
              value: closedKitchen,
              onChanged: (v) {
                widget.onChange(v);
                setState(() {
                  closedKitchen=v!;
                });
              })
        ],
      ),
    );
  }
}

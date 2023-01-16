import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smn_admin/utili/app_config.dart' as config;

class CustomTextInput extends StatelessWidget {
  Function(String?) onChanged;
  String? Function(String?) validator;
  void Function()? onpressed;
  String title;
  String hint;
  TextDirection? textDirection;
  TextInputType? textInputType;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputFormatter? foramtter;

  CustomTextInput({
    Key? key,
    required this.onChanged,
    required this.validator,
    required this.hint,
    required this.title,
    this.focusNode,
    this.textDirection,
    this.textInputType,
    this.controller,
    this.onpressed,
    this.foramtter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: config.App().appWidth(100),
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        onTap: onpressed ?? () {},
        // controller: emailCont,
        key: key,
        textDirection: textDirection,
        textInputAction: TextInputAction.next,
        validator: validator,
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        inputFormatters:foramtter != null ? [foramtter!] :[],
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.all(12),
          hintText: hint,
          hintStyle:
              TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).focusColor.withOpacity(0.2))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).focusColor.withOpacity(0.5))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).focusColor.withOpacity(0.2))),
        ),
      ),
    );
  }
}

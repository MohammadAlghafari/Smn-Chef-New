import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  Function(String?) onChanged;
  String title;
  String hint;
  String? Function(String?) validator;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextDirection? textDirection;

  CustomTextArea(
      {Key? key,
      required this.onChanged,
      required this.hint,
      required this.title,
      this.controller,
      this.focusNode,
      this.textDirection,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          TextFormField(
            // controller: emailCont,
            textInputAction: TextInputAction.newline,
            validator: validator,
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            minLines: 5,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textDirection: textDirection,
            decoration: InputDecoration(
              labelText: title,
              labelStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: const EdgeInsets.all(12),
              hintText: hint,
              hintStyle: TextStyle(
                  color: Theme.of(context).focusColor.withOpacity(0.7)),
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
        ],
      ),
    );
  }
}

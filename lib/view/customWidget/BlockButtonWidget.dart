import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({Key? key, required this.color, required this.text, required this.onPressed}) : super(key: key);

  final Color color;
  final Text text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(

        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: FlatButton(
        onPressed: this.onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 66, vertical: 14),
        color: this.color,
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        child: this.text,
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomClipPathSignUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(size.width / 5, size.height-7 ,size.width- size.width / 4, size.height-80);
    path.quadraticBezierTo(size.width-20, size.height-110, size.width, size.height-30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

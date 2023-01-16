import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);

    path.quadraticBezierTo(size.width / 3, size.height-20 , size.width / 2, size.height-20);
    path.quadraticBezierTo(size.width-size.width / 3, size.height-20, size.width, size.height-30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

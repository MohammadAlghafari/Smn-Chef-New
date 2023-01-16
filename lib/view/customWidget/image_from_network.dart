import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromNetworkWidget extends StatelessWidget {
  final String imageName;
  BoxFit boxFit;
  double width;
  double height;
  ImageFromNetworkWidget(this.imageName,this.width,this.height,{this.boxFit=BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageName,
      fit: boxFit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(value: downloadProgress.progress),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

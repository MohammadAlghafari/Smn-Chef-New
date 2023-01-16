
// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String url;

  const ImageViewer(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myColors;
    return Scaffold(
        body: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(url),
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 25.0,
                  height: 25.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 1.8,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: myColors.orange,
                          child: const Icon(Icons.arrow_back, size: 36.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

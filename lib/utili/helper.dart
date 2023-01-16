import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/data/order/model/food_order.dart';
import 'package:smn_admin/data/order/model/order.dart';
import 'package:smn_admin/data/setting/model/setting.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';

class Helper {
  DateTime? currentBackPressTime;

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "tapBackAgainToLeave");
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }
  OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static Widget getPrice(double myPrice, BuildContext context, Setting setting,
      {TextStyle? style}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize! + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.currencyRight != null && setting.currencyRight == false
            ? TextSpan(
                text: setting.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize! -
                                  6),
                        )
                    : style.merge(TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: style.fontSize! - 6)),
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice
                          .toStringAsFixed(setting.currencyDecimalDigits),
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(setting.currencyDecimalDigits),
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                    text: setting.defaultCurrency,
                    style: style == null
                        ? Theme.of(context).textTheme.subtitle1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .fontSize! -
                                      6),
                            )
                        : style.merge(TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style.fontSize! - 6)),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static String trans(String text, BuildContext context) {
    switch (text) {
      case "App\\Notifications\\OrderCanceled":
        return AppLocalizations.of(context)!.order_satatus_changed;
      case "App\\Notifications\\StatusChangedOrder":
        return AppLocalizations.of(context)!.order_satatus_changed;
      case "App\\Notifications\\NewOrder":
        return AppLocalizations.of(context)!.new_order_from_costumer;
      case "App\\Notifications\\AssignedOrder":
        return AppLocalizations.of(context)!.your_have_an_order_assigned_to_you;
      case "km":
        return AppLocalizations.of(context)!.km;
      case "mi":
        return AppLocalizations.of(context)!.mi;
      case "total_earning":
        return AppLocalizations.of(context)!.totalEarning;
      case "total_orders":
        return AppLocalizations.of(context)!.totalOrders;
      case "total_restaurants":
        return AppLocalizations.of(context)!.totalRestaurants;
      case "total_foods":
        return AppLocalizations.of(context)!.totalFoods;
      default:
        return " ";
    }
  }

  static double getTotalOrdersPrice(Order order) {
    double total = 0;

    if (order != null && order.foodOrders != null) {
      order.foodOrders.forEach((foodOrder) {
        total += getTotalOrderPrice(foodOrder);
      });
      total += order.deliveryFee;
      total += order.tax * total / 100;
    }
    return total;
  }

  static double getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    total *= foodOrder.quantity;
    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    if (order != null && order.foodOrders != null) {
      order.foodOrders.forEach((foodOrder) {
        total += getTotalOrderPrice(foodOrder);
      });
      return order.tax * total / 100;
    } else
      return total;
  }

  static double getOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    return total;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(url.baseUrl).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(url.baseUrl).scheme,
        host: Uri.parse(url.baseUrl).host,
        port: Uri.parse(url.baseUrl).port,
        path: _path + path);
    return uri;
  }

  static getObjectData(dynamic data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static getData(dynamic data) {
    return data['data'] ?? [];
  }

  static double getSubTotalOrdersPrice(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) {
      total += getTotalOrderPrice(foodOrder);
    });
    return total;
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body!.text).documentElement!.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Html applyHtml(context, String html, {TextStyle? style}) {

    return Html(
      data: html,
      style: {
        "*": Style(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).hintColor,
          fontSize: FontSize(16.0),
          display: Display.INLINE_BLOCK,
          width: config.App().appWidth(100),
        ),
        "h4,h5,h6": Style(
          fontSize: FontSize(18.0),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize.xLarge,
        ),
        "br": Style(
          height: 0,
        ),
        "p": Style(
          fontSize: FontSize(16.0),
        )
      },
    );
  }

  static Future<Marker> getRestaurantPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Marker> getMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static getNotificationsData(dynamic data) {
    return data ?? [];
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

   static Future<bool> isNotInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return false;
      }
      return true;
    } catch (e) {
      print('not connected');
      return true;
    }
  }
}

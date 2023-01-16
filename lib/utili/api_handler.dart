import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> getApi(
    {required String url, required Map<String, dynamic> body, required Function result}) async {
  var response = await http.get(Uri.parse(url));

  var map = jsonDecode(response.body);
//  var data = [];
//  if (map['response']['data'] != null) data = map['response']['data'];

  result(response.statusCode, map);
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/order/model/order_status.dart';
import 'package:smn_admin/data/order/model/statistic.dart';
import 'package:smn_admin/data/order/model/order.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/const/url.dart'as url;
import '../../../smn_chef.dart';

class OrderApi {
  Dio dio;

  AuthViewModel authViewModel;

  OrderApi({required this.authViewModel, required this.dio});

  Future<Order> getOrder(orderId) async {
    Uri uri = Helper.getUri('api/orders/$orderId');
    Map<String, dynamic> _queryParams = {};
    if (authViewModel.user!.apiToken == null) {
      return Order.fromJSON({});
    }
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    _queryParams['with'] =
        'driver;user;foodOrders;foodOrders.food;foodOrders.food.restaurant.users;foodOrders.extras;orderStatus;deliveryAddress;payment';
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return Order.fromJSON(response.data['data']);
    } catch (e) {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .the_order_is_not_found));
      return Order.fromJSON({});
    }
  }

  Future<Order> updateOrder(Order order) async {
    Uri uri = Helper.getUri('api/orders/${order.id}');
    if (authViewModel.user!.apiToken == null) {
      return Order.fromJSON({});
    }
    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    uri = uri.replace(queryParameters: _queryParams);
    try {
      print(jsonEncode(order.toMap()));
      final response = await dio.putUri(uri, data: order.editableMap());

      return Order.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Order.fromJSON({});
    }
  }

  Future<Order> cancelOrder(Order order) async {
    Uri uri = Helper.getUri('api/orders/${order.id}');

    if (authViewModel.user!.apiToken == null) {
      return Order.fromJSON({});
    }
    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.putUri(uri, data: order.cancelMap());
      return Order.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Order.fromJSON({});
    }
  }

  Future<List<OrderStatus>> getOrderStatuses() async {
    if(authViewModel.user==null)return [];
    Uri uri = Helper.getUri('api/order_statuses');
    Map<String, dynamic> _queryParams = {};

    _queryParams['api_token'] = authViewModel.user!.apiToken;
    _queryParams['orderBy'] = 'id';
    _queryParams['sortedBy'] = 'asc';
    // _queryParams['filter'] = 'id;status';
    uri = uri.replace(queryParameters: _queryParams);
    if (authViewModel.user!.id == null) {
      return [];
    }
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<OrderStatus>((json) => OrderStatus.fromJSON(json))
          .toList();
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Statistic>> getStatistics(User user) async {
    Map<String, dynamic> _queryParams = {};
    Uri uri = Uri.parse(url.getStatistics(user.id!));
    _queryParams['api_token'] = user.apiToken;
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Statistic>((json) => Statistic.fromJSON(json))
          .toList();
    }catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }

  Future<List<Order>> getOrders(
      {required List<String> statusesIds, required User user,required int page}) async {
    Uri uri = Helper.getUri('api/orders');
    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] = user.apiToken;
    _queryParams['with'] =
    'foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';
    _queryParams['orderBy'] = 'id';
    _queryParams['sortedBy'] = 'desc';

    if (statusesIds.isNotEmpty) {
      _queryParams['statuses[]'] = statusesIds;
    }
    _queryParams['paginate'] = '7';
    _queryParams['page'] = page.toString();
    uri = uri.replace(queryParameters: _queryParams);
    if (user.id == null) return [];
    // jsonMap['active']
    try {
      final response = await dio.getUri(uri);
      return (response.data['data']['data'] as List)
          .map<Order>((json) => Order.fromJSON(json))
          .toList();
    }catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }
}

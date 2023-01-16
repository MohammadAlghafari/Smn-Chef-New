import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/order/model/statistic.dart';
import 'package:smn_admin/data/order/api/order_api.dart';
import 'package:smn_admin/data/order/model/order.dart';

import 'model/order_status.dart';
import 'order_interface.dart';

class OrderRepo implements OrderInterFace{

  OrderApi orderApi;

  OrderRepo({required this.orderApi}) {}
  @override
  Future<Order> getOrder(orderId) {
    return orderApi.getOrder(orderId);
  }

  @override
  Future<Order> cancelOrder(Order order) {
    return orderApi.cancelOrder(order);
  }

  @override
  Future<Order> updateOrder(Order order) {
    return orderApi.updateOrder(order);
  }

  @override
  Future<List<OrderStatus>> getOrderStatuses() {
   return orderApi.getOrderStatuses();
  }

  @override
  Future<List<Statistic>> getStatistics(User user) {
    return orderApi.getStatistics(user);
  }

  @override
  Future<List<Order>> getOrders(List<String> statusesIds, User user,int page ) {
    return orderApi.getOrders(statusesIds: statusesIds, user: user,page:page);
  }

}
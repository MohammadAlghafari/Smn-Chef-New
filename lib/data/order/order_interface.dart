import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/order/model/statistic.dart';

import 'model/order.dart';
import 'model/order_status.dart';

abstract class OrderInterFace {
  Future<Order> getOrder(orderId);

  Future<Order> updateOrder(Order order);

  Future<Order> cancelOrder(Order order);

  Future<List<OrderStatus>> getOrderStatuses();

  Future<List<Statistic>> getStatistics(User user);

  Future<List<Order>> getOrders(List<String> statusesIds, User user,int page);
}

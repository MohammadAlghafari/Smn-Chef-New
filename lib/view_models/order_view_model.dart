import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/order/model/order.dart';
import 'package:smn_admin/data/order/model/order_status.dart';
import 'package:smn_admin/data/order/model/statistic.dart';
import 'package:smn_admin/data/order/order_repo.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';



class OrderViewModel extends ChangeNotifier {
  bool loadingData = true;
  bool loadingStatusData = true;
  OrderRepo orderRepo;
  late Order order;
  List<String> selectedStatuses = [];
  List<OrderStatus> orderStatuses = <OrderStatus>[];
  List<Order> orders = <Order>[];
  AuthViewModel authViewModel;
  List<Statistic> statistics = <Statistic>[];

  ///pagination
  static int page = 0;
  bool isLoading = false;
  final ScrollController sc = ScrollController();

  OrderViewModel({required this.orderRepo, required this.authViewModel}) {
    orders.clear();
    page = 0;
    listenForOrders(statusesIds: []);
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        listenForOrders(statusesIds: selectedStatuses);
      }
    });
    listenForStatistics();
    listenForOrderStatus(insertAll: true);
    selectedStatuses = ['0'];
  }

  void listenForOrders(
      {required List<String> statusesIds, String? message}) async {
    isLoading = true;
    if (page != 0) notifyListeners();
    page++;
    orders.addAll(
        await orderRepo.getOrders(statusesIds, authViewModel.user!, page));
    isLoading = false;
    notifyListeners();
  }

  listenForStatistics() async {
    statistics = await orderRepo.getStatistics(authViewModel.user!);
    notifyListeners();
  }

  void listenForOrder(
      {required String id, String? message, bool withDrivers = false}) async {
    loadingData = true;
    order = await orderRepo.getOrder(id);
    // selectedStatuses = [order.orderStatus.id];
    loadingData = false;
    notifyListeners();
  }

  void doUpdateOrder(Order _order) async {
    Order order = await orderRepo.updateOrder(_order);
    if (order.id == 'null') {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      showSnackBar(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .error_update_order,
      );
      return;
    }
    Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    // Navigator.of(NavigationService.navigatorKey.currentContext!)
    //     .pushReplacementNamed('OrderDetailsScreen', arguments: order.id);
    showSnackBar(
      message:
          AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
              .thisOrderUpdatedSuccessfully,
    );
    orders.clear();
    page = 0;
    listenForOrders(statusesIds: selectedStatuses);
  }

  void doCancelOrder(Order order) async {
    await orderRepo.cancelOrder(order);
    order.active = false;
    showSnackBar(
      message:
          (AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                  .orderIdHasBeenCanceled) +
              " " +
              order.id.toString(),
    );
    orders.clear();
    page = 0;
    listenForOrders(statusesIds: selectedStatuses);
  }

  void listenForOrderStatus({String? message, bool? insertAll}) async {
    loadingStatusData = true;
    orderStatuses = [];
    orderStatuses = await orderRepo.getOrderStatuses();
    loadingStatusData = false;
    if (insertAll != null && insertAll) {
      orderStatuses.insert(
          0,
          OrderStatus.fromJSON({
            'id': '0',
            'status': AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .all
          }));
    }
    notifyListeners();
  }

  Future<void> refreshOrders(BuildContext context) async {
    orders.clear();
    statistics.clear();
    orders.clear();
    page = 0;
    listenForStatistics();
    listenForOrders(
        statusesIds: selectedStatuses,
        message: AppLocalizations.of(context)!.order_refreshed_successfuly);
  }

  Future<void> selectStatus(List<String> statusesIds) async {
    orders.clear();
    page = 0;
    if (statusesIds.contains('1')) {
      listenForRecievedOrders(statusesIds: statusesIds);
    } else {
      listenForOrders(statusesIds: statusesIds);
    }
  }

  void listenForRecievedOrders({statusesIds, String? message}) async {
    orders.addAll(
        await orderRepo.getOrders(statusesIds, authViewModel.user!, page));
    page++;
    orders.removeWhere((element) => !element.active);
    notifyListeners();
  }
}

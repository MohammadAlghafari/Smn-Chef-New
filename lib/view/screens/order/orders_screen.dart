import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/screens/order/widget/empty_orders_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view/screens/order/widget/order_item_widget.dart';
import 'package:smn_admin/view/customWidget/statistics_widgets/statistics_carousel_widget.dart';
import 'package:smn_admin/view_models/order_view_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // NotificationService.initializeNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.menu,
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/img/SMN_final_logo_small.png',
            width: 50, height: 50),
        actions: <Widget>[
          Tooltip(
            message: _trans.notifications,
            child: NotificationButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Consumer<OrderViewModel>(
        builder: (context, orderModel, child) {
          return RefreshIndicator(
            onRefresh: () => orderModel.refreshOrders(context),
            child: ListView(
              controller: orderModel.sc,
              children: [
                StatisticsCarouselWidget(statisticsList: orderModel.statistics),
                Stack(
                  children: [
                    orderModel.orderStatuses.isEmpty
                        ? const SizedBox(height: 90)
                        : SizedBox(
                            height: 90,
                            child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              padding: const EdgeInsetsDirectional.only(end: 20),
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  orderModel.orderStatuses.length, (index) {
                                var _status =
                                    orderModel.orderStatuses.elementAt(index);
                                var _selected = orderModel.selectedStatuses
                                    .contains(_status.id);
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20),
                                  child: RawChip(
                                    elevation: 0,
                                    label: Text(_status.status),
                                    labelStyle: _selected
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                        : Theme.of(context).textTheme.bodyText2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    backgroundColor: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.1),
                                    selectedColor:
                                        Theme.of(context).accentColor,
                                    selected: _selected,
                                    //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                                    showCheckmark: false,
                                    onSelected: (bool value) {
                                      setState(() {
                                        if (_status.id == '0') {
                                          orderModel.selectedStatuses = ['0'];
                                        } else {
                                          orderModel.selectedStatuses
                                              .removeWhere(
                                                  (element) => element == '0');
                                        }
                                        if (value) {
                                          orderModel.selectedStatuses
                                              .add(_status.id);
                                        } else {
                                          orderModel.selectedStatuses
                                              .removeWhere((element) =>
                                                  element == _status.id);
                                        }
                                        orderModel.selectStatus(
                                            orderModel.selectedStatuses);
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                    if (orderModel.orders.isEmpty)
                      EmptyOrdersWidget()
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          reverse: false,
                          itemCount: orderModel.orders.length,
                          itemBuilder: (context, index) {
                            var _order = orderModel.orders.elementAt(index);
                            return OrderItemWidget(
                              expanded: index == 0
                                  ? true
                                  : false,
                              order: _order,
                              onCanceled: (e) {
                                orderModel.doCancelOrder(_order);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                        ),
                      ),
                  ],
                ),
                if(orderModel.isLoading)
                CircularLoadingWidget(height: 10)
              ],
            ),
          );
        },
      ),
    );
  }


}

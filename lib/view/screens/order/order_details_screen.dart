import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/messages/model/conversation.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/screens/order/widget/food_order_item_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view_models/messages_view_model.dart';
import 'package:smn_admin/view_models/order_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String id;

  const OrderDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<OrderViewModel>(context, listen: false)
        .listenForOrder(id: widget.id);
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Consumer2<OrderViewModel, SettingViewModel>(
      builder: (context, orderModel, settingModel, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              tooltip: _trans.back,
              icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
              onPressed: () => Navigator.pop(context),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
          _trans.order_details,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
            actions: <Widget>[
              Tooltip(
                message: _trans.notifications,
                child: NotificationButtonWidget(
                    iconColor: Theme.of(context).hintColor,
                    labelColor: Theme.of(context).accentColor),
              ),
            ],
          ),
          //drawer: const DrawerWidget(),
          bottomNavigationBar: orderModel.loadingData
              ? Container(
                  height: 193,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            offset: const Offset(0, -2),
                            blurRadius: 5.0)
                      ]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                  ),
                )
              : Container(
                  height: orderModel.order.orderStatus.id == '5' ? 210 : 240,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: const Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            offset: const Offset(0, -2),
                            blurRadius: 5.0)
                      ]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _trans.subtotal,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(
                                Helper.getSubTotalOrdersPrice(orderModel.order),
                                context,
                                settingModel.setting,
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _trans.delivery_fee,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(orderModel.order.deliveryFee,
                                context, settingModel.setting,
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${_trans.tax} (${orderModel.order.tax}%)',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(
                                Helper.getTaxOrder(orderModel.order),
                                context,
                                settingModel.setting,
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _trans.total,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Helper.getPrice(
                                double.parse(orderModel.order.payment.price.toString()),
                                context,
                                settingModel.setting,
                                style: Theme.of(context).textTheme.headline6)
                          ],
                        ),
                        orderModel.order.orderStatus.id != '5'
                            ? const Divider(height: 25)
                            : const SizedBox(height: 0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              if (orderModel.order.canEditOrder())
                                OutlineButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        'OrderEditScreen',
                                        arguments: orderModel.order.id);
                                  },
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  textColor: Theme.of(context).accentColor,
                                  disabledTextColor: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  highlightedBorderColor:
                                      Theme.of(context).accentColor,
                                  shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor),
                                  child: Text(
                                    _trans.edit,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              OutlineButton(
                                onPressed: !orderModel.order.canCancelOrder()
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)),
                                              title: Wrap(
                                                spacing: 10,
                                                children: <Widget>[
                                                   Icon(Icons.report,
                                                      color: Theme.of(context).accentColor),
                                                  Text(
                                                    _trans.confirmation,
                                                    style:  TextStyle(
                                                        color: Theme.of(context).accentColor),
                                                  ),
                                                ],
                                              ),
                                              content: Text(_trans
                                                  .areYouSureYouWantToCancelThisOrderOf),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 25),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child:  Text(
                                                    _trans.close,
                                                    style:  TextStyle(
                                                        color: Theme.of(context).accentColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),

                                                FlatButton(
                                                  child:  Text(
                                                    _trans.yes,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<OrderViewModel>(
                                                            context,
                                                            listen: false)
                                                        .doCancelOrder(
                                                            orderModel.order);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                textColor: Theme.of(context).accentColor,
                                disabledTextColor: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5),
                                highlightedBorderColor:
                                    Theme.of(context).accentColor,
                                shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                child: Text(
                                  _trans.cancel,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
          body: orderModel.loadingData
              ? Container(child: CircularLoadingWidget(height: 400))
              : getOrderWidget(orderModel, settingModel),
        );
      },
    );
  }

  void _userChat(OrderViewModel orderModel) async {
    Restaurant _restaurant = orderModel.order.foodOrders[0].food.restaurant;
    List<String> chatOwners = [];
    for (int i = 0; i < _restaurant.users.length; i++) {
      chatOwners.add(_restaurant.users[i].id!);
    }
    chatOwners.add(orderModel.order.user.id!);
    List<User> users = _restaurant.users.map((e) {
      e.image = _restaurant.image;
      return e;
    }).toList();
    users.add(orderModel.order.user);
    var id = await Provider.of<MessagesViewModel>(context, listen: false)
        .getConversation(chatOwners);

    Navigator.of(context).pushNamed(
      'ChatScreen',
      arguments: {
        'Conversation': Conversation.fromJSONRestaurant({
          'users': users,
          'name': _restaurant.name,
          'id': id,
        }),
        'restaurantId': _restaurant.id
      },
    );
    // var id = await ChatRepository.getConversation(chatOwners);
    // Navigator.of(context).pushNamed(
    //   '/Chat',
    //   arguments: RouteArgument(
    //       param: new Conversation(users, name: _restaurant.name, id: id),
    //       id: _restaurant.id),
    // );
  }

  getOrderWidget(OrderViewModel orderModel, SettingViewModel settingModel) {
    if (orderModel.order.id == 'null') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/Error.png',
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              _trans.the_order_is_not_found,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 40,
            ),
            IconButton(
                onPressed: () {
                  Provider.of<OrderViewModel>(context, listen: false)
                      .listenForOrder(id: widget.id);
                },
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).hintColor,
                  size: 35,
                ))
          ],
        ),
      );
    }
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        snap: true,
        floating: true,
        automaticallyImplyLeading: false,
        // leading:  IconButton(
        //     icon:  Icon(Icons.sort, color: Theme.of(context).hintColor),
        //     onPressed: () => scaffoldKey.currentState!.openDrawer()),
        // centerTitle: true,
        // title: Text(
        //   _trans.order_details,
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline6!
        //       .merge(const TextStyle(letterSpacing: 1.3)),
        // ),
        // actions: <Widget>[
        //   NotificationButtonWidget(
        //       iconColor: Theme.of(context).hintColor,
        //       labelColor: Theme.of(context).colorScheme.secondary),
        // ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        expandedHeight: 249,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            margin: const EdgeInsets.only(top: 50, bottom: 65),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _trans.order_id + ": #${orderModel.order.id}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              orderModel.order.orderStatus.status,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              _trans.orderDeliveryTime +
                                  ' ' +
                                  DateFormat('HH:mm | yyyy-MM-dd').format(orderModel.order.dateTime) +
                                  ' ' +
                                  orderModel.order.time,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Helper.getPrice(
                               double.parse(orderModel.order.payment.price.toString()),
                              context,
                              settingModel.setting,
                              style: Theme.of(context).textTheme.headline4),
                          Text(
                            orderModel.order.payment.method ??
                                _trans.cash_on_delivery,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            _trans.items +
                                ':' +
                                orderModel.order.foodOrders.length.toString(),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          collapseMode: CollapseMode.pin,
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            unselectedLabelColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).primaryColor,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).accentColor),
            tabs: [
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Theme.of(context).accentColor.withOpacity(0.2),
                          width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(_trans.ordered_foods),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Theme.of(context).accentColor.withOpacity(0.2),
                          width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(_trans.customer),
                  ),
                ),
              ),
            ]),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Offstage(
            offstage: 0 != _tabIndex,
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 20, bottom: 50),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: orderModel.order.foodOrders.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 15);
              },
              itemBuilder: (context, index) {
                return FoodOrderItemWidget(
                    heroTag: 'my_orders',
                    order: orderModel.order,
                    foodOrder: orderModel.order.foodOrders.elementAt(index));
              },
            ),
          ),
          Offstage(
            offstage: 1 != _tabIndex,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _trans.fullName,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              orderModel.order.user.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: FlatButton(
                          padding: const EdgeInsets.all(0),
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.4),
                          onPressed: () {
                            _userChat(orderModel);
                          },
                          //onPressed: () {
                          //                          Navigator.of(context).pushNamed('/Profile',
                          //                          arguments: new RouteArgument(param: orderModel.order.deliveryAddress));
                          //},
                          child: Icon(
                            Icons.message,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          color: Theme.of(context).accentColor.withOpacity(0.9),
                          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _trans.deliveryAddress,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              orderModel.order.deliveryAddress.address ??
                                  _trans
                                      .address_not_provided_please_call_the_client,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(
                        width: 42,
                        height: 42,
                        //                            child: FlatButton(
                        //                            padding: EdgeInsets.all(0),
                        //                            disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                        //                              onPressed: () {
                        //                          Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '3', param: orderModel.order));
                        //                              },
                        //                              child: Icon(
                        //                                Icons.directions,
                        //                                color: Theme.of(context).primaryColor,
                        //                                size: 24,
                        //                             ),
                        //                              color: Theme.of(context).accentColor.withOpacity(0.9),
                        //                              shape: StadiumBorder(),
                        //                           ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _trans.phoneNumber,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              orderModel.order.user.phone ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: FlatButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            launch("tel:${orderModel.order.user.phone}");
                          },
                          child: Icon(
                            Icons.call,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          color: Theme.of(context).accentColor.withOpacity(0.9),
                          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      )
    ]);
  }
}

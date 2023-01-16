import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view_models/order_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

class OrderEditScreen extends StatefulWidget {
  final String id;

  const OrderEditScreen({Key? key, required this.id}) : super(key: key);

  @override
  _OrderEditScreenState createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends State<OrderEditScreen> {
  late AppLocalizations _trans;

  @override
  void initState() {
    Provider.of<OrderViewModel>(context, listen: false)
        .listenForOrder(id: widget.id);
    Provider.of<OrderViewModel>(context, listen: false)
        .listenForOrderStatus(insertAll: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      //drawer: const DrawerWidget(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: FlatButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text(_trans.confirmation),
                    content: Text(_trans
                        .would_you_please_confirm_if_you_want_to_save_changes),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child:  Text(_trans.cancel),
                        textColor: Theme.of(context).focusColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: Text(_trans.confirm),
                        onPressed: () {
                          buildShowDialog(context);
                          Provider.of<OrderViewModel>(context, listen: false)
                              .doUpdateOrder(Provider.of<OrderViewModel>(
                              context,
                              listen: false)
                              .order);
                        },
                      ),

                    ],
                  );
                });
          },
          padding: const EdgeInsets.symmetric(vertical: 14),
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            _trans.saveChanges,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
      appBar: AppBar(
        leading:  IconButton(
          tooltip: _trans.back,
          icon:  Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          _trans.editOrder,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Tooltip(
            message: _trans.notifications,
            child: NotificationButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ),
        ],
      ),
      body: Consumer<OrderViewModel>(
        builder: (context, orderModel, child) {
          return orderModel.loadingData
              ? CircularLoadingWidget(height: 400)
              : getOrderWidget(orderModel);
        },
      ),
    );
  }

  getOrderWidget(OrderViewModel orderModel) {
    if (orderModel.order.id == 'null') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/Error.png',width: 200,),
            const SizedBox(height: 30,),
            Text(
              _trans.oops_Check_your_internet_connection,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40,),
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
    return ListView(
      primary: true,
      shrinkWrap: false,
      children: [
        Container(
//                  margin: EdgeInsets.only(top: 95, bottom: 65),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                DateFormat('HH:mm | yyyy-MM-dd').format(orderModel.order.dateTime)+
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
                        Consumer<SettingViewModel>(
                          builder: (context, settingModel, child) {
                            return Helper.getPrice(
                                Helper.getTotalOrdersPrice(orderModel.order),
                                context,
                                settingModel.setting,
                                style: Theme.of(context).textTheme.headline4);
                          },
                        ),
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
        ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
//                    title: Text("Assign Delivery Boy"),
            title: Text(_trans.orderStatus),
            initiallyExpanded: true,
            textColor: Theme.of(context).accentColor,
            iconColor: Theme.of(context).accentColor,
            children: List.generate(orderModel.orderStatuses.length, (index) {
              var _status = orderModel.orderStatuses.elementAt(index);
              if(_status.id=='0')return Container();
              return RadioListTile(
                dense: true,
                groupValue: true,
                controlAffinity: ListTileControlAffinity.trailing,
                value: orderModel.order.orderStatus.id == _status.id,
                onChanged: int.parse(_status.id) >=
                        int.parse(orderModel.order.orderStatus.id)
                    ? (value) {
                        setState(() {
                          orderModel.order.orderStatus = _status;
                        });
                      }
                    : null,
                title: Text(
                  " " + _status.status,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
              );
            })),
      ],
    );
  }
}

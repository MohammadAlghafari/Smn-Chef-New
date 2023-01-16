import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/view_models/notifications_view_model.dart';

import 'widget/empty_notifications_widget.dart';
import 'widget/notification_item_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Consumer<NotificationsViewModel>(
      builder: (context, notificationsModel, child) {
        return Scaffold(
          key: scaffoldKey,

          //drawer: DrawerWidget(),
          appBar: AppBar(
            leading: IconButton(
              tooltip: _trans.back,
              icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                  color: Theme.of(context).hintColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              _trans.notifications,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(letterSpacing: 1.3)),
            ),

          ),
          body: RefreshIndicator(
            onRefresh: notificationsModel.refreshNotifications,
            child: notificationsModel.notifications
                    .where((element) => element.createdAt != DateTime(0))
                    .toList()
                    .isEmpty
                ? EmptyNotificationsWidget()
                : ListView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.notifications,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            _trans.notifications,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            _trans
                                .swip_left_the_notification_to_delete_or_read__unread,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: notificationsModel.notifications
                            .where(
                                (element) => element.createdAt != DateTime(0))
                            .toList()
                            .length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, index) {
                          return NotificationItemWidget(
                            notification: notificationsModel.notifications
                                .where((element) =>
                                    element.createdAt != DateTime(0))
                                .toList()
                                .elementAt(index),
                            onMarkAsRead: () {
                              notificationsModel.doMarkAsReadNotifications(
                                  notificationsModel.notifications
                                      .where((element) =>
                                          element.createdAt != DateTime(0))
                                      .toList()
                                      .elementAt(index));
                            },
                            onMarkAsUnRead: () {
                              notificationsModel.doMarkAsUnReadNotifications(
                                  notificationsModel.notifications
                                      .where((element) =>
                                          element.createdAt != DateTime(0))
                                      .toList()
                                      .elementAt(index));
                            },
                            onRemoved: () {
                              notificationsModel.doRemoveNotification(
                                  notificationsModel.notifications
                                      .where((element) =>
                                          element.createdAt != DateTime(0))
                                      .toList()
                                      .elementAt(index));
                            },
                          );
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

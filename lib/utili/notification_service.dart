import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/order_view_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static void initializeNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (Platform.isIOS) iOS_Permission();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('Message also contained a notification: ${message.notification}');
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('SMN_CHEF', 'your channel name',
                importance: Importance.max,
                priority: Priority.high,
                showWhen: false);
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            platformChannelSpecifics,
            payload: 'shopper');
        if (message.data['title'] == 'Deactivated' ||
            message.data['title'] == 'Activated') {
          Provider.of<AuthViewModel>(
                  NavigationService.navigatorKey.currentState!.context,
                  listen: false)
              .checkExistRestaurant();
        } else if (message.data['title'].toString().contains('New Order')) {
          Provider.of<OrderViewModel>(
                  NavigationService.navigatorKey.currentState!.context,
                  listen: false)
              .refreshOrders(
                  NavigationService.navigatorKey.currentState!.context);
        }
      }
      // Provider notify
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Provider notify
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      // Provider notify

      return;
    });
  }

  static void iOS_Permission() async {
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  static void selectNotification(String? payload) {}
}

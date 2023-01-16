import 'package:smn_admin/data/auth/model/user.dart';

import 'model/notification.dart';

abstract class NotificationsInterface {
  Future<List<Notification>> getNotifications();

  Future<Notification> markAsReadNotifications(Notification notification);

  Future<Notification> removeNotification(Notification cart);

  Future<void> sendNotification(String body, String title, User user);
}

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificator/Controller/readFile.dart';
import 'package:notificator/main.dart';

class Notificator {
  static final Notificator _instance = Notificator._internal();

  String _notificationTitle = "Reminder";
  int _delaySeconds = 60;

  factory Notificator() {
    return _instance;
  }

  Notificator._internal();

  String get notificationTitle => _notificationTitle;
  void setNotificationTitle(String title) {
    _notificationTitle = title;
  }

  int get delaySeconds => _delaySeconds;
  void setdelaySeconds(int seconds) {
    _delaySeconds = seconds;
  }

  void runNotificationLoop(String filePath) async {
    final random = Random();
    try {
      final lines = await FileController().readLine(filePath);

      if (lines.isNotEmpty) {
        final line = lines[random.nextInt(lines.length)];

        showNotification(_notificationTitle, line);
      } else {
        showNotification(
          _notificationTitle,
          "No Data inside file. Add some Lines",
        );
      }
    } catch (e) {
      showNotification("Notification Error", ('Error: $e'));
    }
  }

  void showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        windows: WindowsNotificationDetails(),
        linux: LinuxNotificationDetails(
          icon: AssetsLinuxIcon('Assets/AppIcon.png'),
          urgency: LinuxNotificationUrgency.normal,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

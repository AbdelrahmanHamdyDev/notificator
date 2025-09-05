import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificator/Controller/readFile.dart';
import 'package:notificator/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notificator {
  static final Notificator _instance = Notificator._internal();

  String _notificationTitle = "Reminder";
  int _delaySeconds = 60;

  factory Notificator() {
    return _instance;
  }

  Notificator._internal();

  String get notificationTitle => _notificationTitle;
  Future<void> setNotificationTitle(String title) async {
    _notificationTitle = title;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("notificationTitle", title);
  }

  int get delaySeconds => _delaySeconds;
  Future<void> setDelaySeconds(int seconds) async {
    _delaySeconds = seconds;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("delaySeconds", seconds);
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationTitle = prefs.getString("notificationTitle") ?? "Reminder";
    _delaySeconds = prefs.getInt("delaySeconds") ?? 60;
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

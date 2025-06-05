import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificator/Controller/readFile.dart';
import 'package:notificator/main.dart';

class Notificator {
  void runNotificationLoop(String filePath) async {
    final random = Random();
    try {
      final lines = await FileController().readLine(filePath);

      if (lines.isNotEmpty) {
        final line = lines[random.nextInt(lines.length)];

        showNotification(
          "﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ﴾",
          line,
        );
      } else {
        showNotification(
          "﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ﴾",
          "No Data inside file. Add some Lines",
        );
      }
    } catch (e) {
      showNotification("Error", ('Error: $e'));
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

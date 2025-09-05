import 'dart:io';
import 'package:notificator/Controller/controller.dart';
import 'package:notificator/Controller/readFile.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificator/homeScreen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<String> copyAssetToFile(String asset, String filename) async {
  final byteData = await rootBundle.load(asset);
  final file = File(
    '${(await getApplicationSupportDirectory()).path}/$filename',
  );
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificator = Notificator();
  await notificator.loadPreferences();
  await windowManager.ensureInitialized();
  const initializationSettings = InitializationSettings(
    windows: WindowsInitializationSettings(
      appName: 'Notificator',
      appUserModelId: 'Notificator',
      guid: '51a35bb0-e035-461e-b880-7b34ddcd9448',
      iconPath: 'Assets/AppIcon.png',
    ),
    linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
    macOS: DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
    ),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  setWindowMinSize(const Size(400, 500));
  setWindowMaxSize(const Size(400, 500));

  WindowOptions options = const WindowOptions(
    size: Size(400, 500),
    center: true,
    skipTaskbar: true,
    title: "Notificator",
  );
  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.hide();
  });

  if (Platform.isWindows) {
    final iconPath = await copyAssetToFile('Assets/AppIcon.ico', 'AppIcon.ico');
    await trayManager.setIcon(iconPath);
  } else {
    final iconPath = await copyAssetToFile('Assets/AppIcon.png', 'AppIcon.png');
    await trayManager.setIcon(iconPath);
  }

  trayManager.addListener(MyTrayListener());
  final txtPath = await FileController().prepareTxtFile();

  runApp(MaterialApp(home: homeScreen(txtPath: txtPath)));
}

class MyTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
    await windowManager.focus();
  }
}

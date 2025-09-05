import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileController {
  Future<String> prepareTxtFile() async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/Notificator.txt');

    if (!await file.exists()) {
      await file.writeAsString(
        "Welcome to Notificator! Add your reminders here.",
      );
    } else {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        await file.writeAsString(
          "Welcome to Notificator! Add your reminders here.",
        );
      }
    }

    return file.path;
  }

  Future<List<String>> readLine(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      print('File not found: $filePath');
      createFile(filePath);
      await Future.delayed(Duration(seconds: 10));
    }

    final content = await file.readAsString();
    return content
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void createFile(String filePath) {
    final file = File(filePath);
    file.createSync();
  }

  void openTxtFile(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      createFile(filePath);
    }
    await Process.start(
      Platform.isWindows
          ? 'start'
          : Platform.isMacOS
          ? 'open'
          : 'xdg-open',
      [filePath],
      runInShell: true,
    );
  }
}

import 'dart:io';

class FileController {
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

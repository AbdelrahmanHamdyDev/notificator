import 'package:flutter/material.dart';
import 'package:notificator/Controller/controller.dart';
import 'package:notificator/Controller/readFile.dart';
import 'package:notificator/settingScreen.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool repeat = false;
  final notificator = Notificator();

  Future<void> startNotificationLoop() async {
    notificator.runNotificationLoop('Assets/Notificator.txt');
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF6C63FF);
    final Color backgroundColor = Color(0xFFF6F5FA);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => settingScreen()));
          },
          icon: Icon(Icons.settings),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(10, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              // Open Txt File Button
              ElevatedButton(
                onPressed: () {
                  FileController().openTxtFile("Assets/Notificator.txt");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  foregroundColor: Colors.black,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text("Open '.txt' File"),
                ),
              ),

              const SizedBox(height: 10),
              // Start/Stop Button
              ElevatedButton(
                onPressed: () async {
                  setState(() => repeat = !repeat);
                  while (repeat) {
                    await startNotificationLoop();
                    await Future.delayed(
                      Duration(seconds: notificator.delaySeconds),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: repeat ? Colors.redAccent : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                ),
                child: Text(repeat ? 'Stop' : 'Start'),
              ),

              //test
              ElevatedButton(
                onPressed: () async {
                  await startNotificationLoop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                ),
                child: Text('test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notificator/Controller/controller.dart';
import 'package:notificator/Controller/readFile.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  TextEditingController delayController = TextEditingController();
  bool repeat = false;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF6C63FF);
    final Color backgroundColor = Color(0xFFF6F5FA);

    Future<void> startNotificationLoop() async {
      Notificator().runNotificationLoop('Assets/Notificator.txt');
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
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

              // Delay Input
              TextField(
                controller: delayController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: Text("Min"),
                  labelText: 'Enter Delay Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Start/Stop Button
              ElevatedButton(
                onPressed: () async {
                  setState(() => repeat = !repeat);
                  while (repeat) {
                    await startNotificationLoop();
                    if (delayController.text.trim().isEmpty) {
                      delayController.text = "1";
                    }
                    final delayMinutes =
                        int.tryParse(delayController.text) ?? 1;
                    await Future.delayed(Duration(minutes: delayMinutes));
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

import 'package:flutter/material.dart';
import 'package:notificator/Controller/controller.dart';

class settingScreen extends StatefulWidget {
  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  TextEditingController delayController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final notificator = Notificator();

  @override
  void initState() {
    super.initState();
    titleController.text = notificator.notificationTitle;
    delayController.text = notificator.delaySeconds.toString();
  }

  @override
  void dispose() {
    titleController.dispose();
    delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF6C63FF);
    return Scaffold(
      appBar: AppBar(),
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
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Notification Title Input
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Delay Input
              TextField(
                controller: delayController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: Text("sec"),
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
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  notificator.setNotificationTitle(titleController.text);
                  notificator.setdelaySeconds(int.parse(delayController.text));
                  Navigator.of(context).pop();
                },
                child: Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

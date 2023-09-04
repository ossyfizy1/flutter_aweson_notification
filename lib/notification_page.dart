import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class MyNotificationPage extends StatefulWidget {
  final ReceivedAction receivedAction;
  const MyNotificationPage({super.key, required this.receivedAction});

  @override
  State<MyNotificationPage> createState() => _MyNotificationPageState();
}

class _MyNotificationPageState extends State<MyNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Notification Page${widget.receivedAction.buttonKeyPressed}")
          ],
        ),
      ),
    );
  }
}

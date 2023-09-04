import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? mtoken;

  Future<void> _incrementCounter() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token!;
      log("My device token: $mtoken");
    });

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'kokfp-basic_channel',
          title: 'Initiated Notification',
          body: 'Initiated body',
          actionType: ActionType.Default,
        ),
        actionButtons: [
          NotificationActionButton(
              key: "Accept Call", label: "Accept Call", color: Colors.green),
          NotificationActionButton(
            key: "Reject Call",
            label: "Reject Call",
            color: Colors.red,
            // actionType: ActionType.DisabledAction,
          )
        ]);

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Your Device ID"),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: mtoken ?? ""));
                    // copied successfully
                  },
                  child: Text(mtoken ?? "")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

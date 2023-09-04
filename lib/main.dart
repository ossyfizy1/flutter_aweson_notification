import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_notification/home_page.dart';
import 'package:flutter_awesome_notification/notification_page.dart';

// to listen for push notification while app is in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("handling a background message ${message.notification?.title}/${message.notification?.body}");

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        category: NotificationCategory.Call,
        channelKey: 'kokfp-basic_channel',
        groupKey: 'kokfp-basic_channel_group',
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        locked: true,
        criticalAlert: true,
        title: message.notification?.title,
        body: message.notification?.body,
        actionType: ActionType.Default,
        payload: {"name": "FlutterCampus"},
      ),
      actionButtons: [
        NotificationActionButton(
            key: "Accept Call", label: "Accept Call", color: Colors.green),
        NotificationActionButton(
          key: "Reject Call",
          label: "Reject Call",
          color: Colors.red,
          actionType: ActionType.DisabledAction,
        )
      ]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Push Notification Tutorial at https://www.youtube.com/watch?v=AUU6gbDni4Q&t=11s
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    log("-----------------onMesage------------------");
    log("onMessage: ${message.notification?.title}/${message.notification?.body}");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'kokfp-basic_channel',
        title: 'All Foreground Notification',
        body: 'All Foreground body',
        actionType: ActionType.Default,
      ),
    );
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // start of Awesome notification
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'kokfp-basic_channel_group',
          channelKey: 'kokfp-basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          enableVibration: true,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'kokfp-basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
                builder: (context) => const MyHomePage(title: MyApp.name));

          case '/notification-page':
            return MaterialPageRoute(
              builder: (context) {
                final ReceivedAction receivedAction =
                    settings.arguments as ReceivedAction;
                return MyNotificationPage(receivedAction: receivedAction);
              },
            );

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}

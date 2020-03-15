import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutternews/services/news.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'themes/maintheme.dart';

//Theme Data
ThemeData myAppTheme;

//Saved settings
SharedPreferences prefs;

//Daily Notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  runApp(MyApp());

  //Setup the local daily notifications
  setupNotifications();

  initPlatformState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Load the Theme
    myAppTheme = getMainThemeWithBrightness(context, Brightness.light);

    return MaterialApp(
      title: 'Flutter News App',
      theme: myAppTheme,
      home: MyHomePage(),
    );
  }
}

setupNotifications() async {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
  //Complete process
  //For out use case, nothing needed
}

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  //Complete process
  //For out use case, nothing needed
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  // Configure BackgroundFetch.
  BackgroundFetch.configure(
          BackgroundFetchConfig(
              minimumFetchInterval: 5,
              stopOnTerminate: false,
              enableHeadless: false,
              requiresBatteryNotLow: false,
              requiresCharging: true,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY),
          executeBackgroundTask)
      .then((int status) {
    print('[BackgroundFetch] configure success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] configure ERROR: $e');
  });

  //Schedule the background task
  BackgroundFetch.scheduleTask(TaskConfig(taskId: "com.praharsh.flutternews", delay: 60000));
}

Future executeBackgroundTask(String taskId) async {
  //Get the background fetch setting
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool blBackgroundLoad = prefs.getBool("background load") ?? false;

  if (blBackgroundLoad) {
    //Check if the last updated day way today
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/news.xml');
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final fileDate = DateTime(file.lastModifiedSync().year, file.lastModifiedSync().month, file.lastModifiedSync().day);

    if (fileDate.isBefore(today)) {
      await fetchNews();

      //Send a push notification
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin
          .show(0, "News Loaded", "Tap here to read the latest headlines", platformChannelSpecifics, payload: 'item x');

      //End this background process
      BackgroundFetch.finish(taskId);
    } else {
      //End this background process
      BackgroundFetch.finish(taskId);
    }
  } else {
    //End this background process
    BackgroundFetch.finish(taskId);
  }
}

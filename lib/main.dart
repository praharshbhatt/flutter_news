import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  setupNotifications();
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

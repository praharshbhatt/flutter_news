import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutternews/main.dart';

import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/article.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //Saved settings
  SharedPreferences prefs;

  bool blBackgroundLoad = false, blDailyNotification = false;
  TimeOfDay todNotification;

  @override
  void initState() {
    loadSavedData();

    super.initState();
  }

  //Load the saved settings data
  loadSavedData() async {
    prefs = await SharedPreferences.getInstance();

    //Get the background load setting
    setState(() {
      //Get background load
      blBackgroundLoad = prefs.getBool("background load") ?? false;

      //Get background notification
      blDailyNotification = prefs.getBool("daily notification") ?? false;

      //Get background notification time
      String strNotification = prefs.getString("daily notification time") ?? null;
      if (strNotification != null && strNotification != "") {
        strNotification = strNotification.replaceAll("TimeOfDay(", "").replaceAll(")", "");
        todNotification =
            TimeOfDay(hour: int.parse(strNotification.split(":")[0]), minute: int.parse(strNotification.split(":")[1]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Settings",
            style: myAppTheme.textTheme.caption.copyWith(color: Colors.white),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            //Background fetch
            ListTile(
              title: Text("Background news update", style: myAppTheme.textTheme.bodyText1),
              subtitle: Text("Fetches news data in the background when the phone is on charge.",
                  style: myAppTheme.textTheme.bodyText2),
              trailing: Switch(
                  value: blBackgroundLoad,
                  onChanged: (val) {
                    setState(() {
                      blBackgroundLoad = val;
                      prefs.setBool("background load", blBackgroundLoad);
                    });
                  }),
            ),

            //Daily reminder
            ListTile(
              title: Text("Daily reminder notification", style: myAppTheme.textTheme.bodyText1),
              subtitle: Text("Daily news reminder notifications", style: myAppTheme.textTheme.bodyText2),
              trailing: Switch(
                  value: blDailyNotification,
                  onChanged: (val) async {
                    setState(() {
                      blDailyNotification = val;
                      prefs.setBool("daily notification", blDailyNotification);
                    });

                    if (val == false) {
                      flutterLocalNotificationsPlugin.cancelAll();
                    } else if (todNotification != null) {
                      setDailyNotifications();
                    }
                  }),
            ),

            //Daily reminder time
            blDailyNotification
                ? ListTile(
                    title: Text("Daily reminder notification time", style: myAppTheme.textTheme.bodyText1),
                    subtitle: Text(
                        "Choose time to receive daily news notification\n" +
                            (todNotification == null ? "(not set)" : todNotification.toString()),
                        style: myAppTheme.textTheme.bodyText2),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      //Set the Daily reminder time
                      if (todNotification == null) todNotification = TimeOfDay(hour: 0, minute: 0);

                      todNotification = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day, todNotification.hour, todNotification.minute) ??
                            DateTime.now()),
                      );

                      if (blDailyNotification != null)
                        prefs.setString("daily notification time", todNotification.toString());

                      setDailyNotifications();

                      setState(() {});
                    },
                  )
                : Container()
          ],
        ));
  }

  setDailyNotifications() async {
    //Cancel all the previous notifications
    flutterLocalNotificationsPlugin.cancelAll();

    //Set the time of schedules notifications
    var time = Time(todNotification.hour, todNotification.minute, 0);

    //Schedule Notifications
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id', 'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, "Today's News", "Tap to see today's headlines", time, platformChannelSpecifics);
  }
}

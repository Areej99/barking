import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' as io show File, Platform;
import 'package:rxdart/subjects.dart';




class NotificationPlugin {
  var initializationSettings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<RecievedNotification>
      didRecievedLocalNotificationSubject =
      BehaviorSubject<RecievedNotification>();
  NotificationPlugin._() {
    init();
  }

  void init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (io.Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();

  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/car');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          RecievedNotification recievedNotification = RecievedNotification(
              id: id, title: title, body: body, payload: payload);
          didRecievedLocalNotificationSubject.add(recievedNotification);
        });

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didRecievedLocalNotificationSubject.listen((recievedNotification) {
      onNotificationInLowerVersions(recievedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    // ignore: missing_return
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // ignore: missing_return
        onSelectNotification: (String payload) {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotifications() async {
    var notificatonTime = DateTime.now().add(Duration(seconds: 10));
    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', 'CHANNEL_DESCRIPTION',
        enableLights: true,
        ledColor: const Color.fromARGB(0, 225, 0, 0),
        ledOffMs: 5000,
        ledOnMs: 2000,
        largeIcon: DrawableResourceAndroidBitmap('mipmap/car'),
        importance: Importance.Max, priority: Priority.High,playSound: true,timeoutAfter: 2000,
    styleInformation: DefaultStyleInformation(true,true));

    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, 'Garage', 'you have half hour left', notificatonTime,platformChannelSpecifics,
        payload: 'test payload');
  }

  // Future<void> showMessagingNotification() async {
  //   // use a platform channel to resolve an Android drawable resource to a URI.
  //   // This is NOT part of the notifications plugin. Calls made over this channel is handled by the app
  //   //String imageUri = await platform.invokeMethod('drawableToUri', 'food');
  //   var messages = List<Message>();
  //   // First two person objects will use icons that part of the Android app's drawable resources
  //
  //   var coworker = Person(
  //     name: 'Coworker',
  //     key: '2',
  //     uri: 'tel:9876543210',
  //     icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  //   );
  //   // download the icon that would be use for the lunch bot person
  //
  //   // this person object will use an icon that was downloaded
  //
  //   messages.add(Message(
  //       'What\'s up?', DateTime.now().add(Duration(minutes: 5)), coworker));
  //
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'message channel id',
  //       'message channel name',
  //       'message channel description',
  //       category: 'msg',
  //    );
  //   var platformChannelSpecifics =
  //   NotificationDetails(androidPlatformChannelSpecifics, null);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'message title', 'message body', platformChannelSpecifics);
  //
  //   // wait 10 seconds and add another message to simulate another response
  //   await Future.delayed(Duration(seconds: 10), () async {
  //     messages.add(
  //         Message('Thai', DateTime.now().add(Duration(minutes: 11)), null));
  //     await flutterLocalNotificationsPlugin.show(
  //         0, 'message title', 'message body', platformChannelSpecifics);
  //   });
  // }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class RecievedNotification {
  //for lower versions of ios
  final int id;
  final String title;
  final String body;
  final String payload;
  RecievedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

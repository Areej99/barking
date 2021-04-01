import 'package:barking/screens/home_page.dart';
import 'package:barking/screens/login_page.dart';
import 'package:barking/widgets/reusable_button.dart';
import 'package:barking/components/notification_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

//NotificationPlugin notificationPlugin = NotificationPlugin._();
final _fireStoreVar = FirebaseFirestore.instance;

class CostPage extends StatefulWidget {
  CostPage({this.to, this.from, this.extra});
  final int to;
  final int from;
  final bool extra;
  @override
  _CostPageState createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<Data>(context).uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.extra ? 'Extra hours cost' : 'Cost' ,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'cost per hour : ',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '10 KWD',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'total number of hour : ',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${(widget.to - widget.from).toString()} H',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'total cost : ',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${((widget.to - widget.from) * 10).toString()} KWD',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              ButtonWidget(
                myText: 'Confirm',
                myColor: Colors.teal,
                onPressed: () async {
                  if (!widget.extra) {
                    _fireStoreVar
                        .collection('timeRange')
                        .doc(uid)
                        .set({'to': widget.to, 'from': widget.from});
                    print(
                        '---------------------------------------------------------------------------------------------');
                    print('${widget.to}     ${widget.from}  ');
                    print(
                        '---------------------------------------------------------------------------------------------');
                    await notificationPlugin.showNotifications();
                    //await notificationPlugin.showMessagingNotification();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MyHomePage();
                      },
                    ));
                  } else {
                    print(
                        '---------------------------------------------------------------------------------------------');

                    print(
                        '---------------------------------------------------------------------------------------------');
                    _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  onNotificationInLowerVersions(RecievedNotification recievedNotification) {}
  onNotificationClick(String payload) {
    print('payload $payload ------------------------------------------');
  }
}

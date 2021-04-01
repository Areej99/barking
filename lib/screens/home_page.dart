import 'package:barking/screens/park_request_page.dart';
import 'package:barking/screens/cost_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barking/model/data.dart';
import 'package:barking/widgets/app_bar_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final _firestoreVar = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  List<Text> buttonList = [];
  void getButtonList() {
    for (int i = 0; i < 5; i++) {
      final button = Text(i.toString());
      setState(() {
        buttonList.add(button);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<Data>(context).uid;
    String availability1 = Provider.of<Data>(context).availability1;
    String availability2 = Provider.of<Data>(context).availability2;
    String availability3 = Provider.of<Data>(context).availability3;
    String availability4 = Provider.of<Data>(context).availability4;

    bool available1 = Provider.of<Data>(context).available1;
    bool available2 = Provider.of<Data>(context).available2;
    bool available3 = Provider.of<Data>(context).available3;
    bool available4 = Provider.of<Data>(context).available4;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Find parking',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            physics: AlwaysScrollableScrollPhysics(),
            labelColor: Colors.white,
            tabs: [
              AppBarTab(area:'area 1' ,availability: availability1,available: available1, ),
              AppBarTab(area:'area 2' ,availability: availability2,available: available2, ),
              AppBarTab(area:'area 3' ,availability: availability3,available: available3, ),
              AppBarTab(area:'area 4' ,availability: availability4,available: available4, ),

            ],
            //controller: tabController1,
          ),
        ),
        body: TabBarView(
          children: [
            ParkRequest(
              available: available1,
              parkingPage: 1,
            ),
            ParkRequest(
              available: available2,
              parkingPage: 2,
            ),
            ParkRequest(
              available: available3,
              parkingPage: 3,
            ),
            ParkRequest(
              available: available4,
              parkingPage: 4,
            ),

            // Opacity(
            //     opacity: controller.value,
            //     child: Container(
            //       width: 100,
            //       height: 100,
            //       child: FlatButton(
            //         child: Text('changed'),
            //         color: Colors.green,
            //         onPressed: () {},
            //       ),
            //     )),
            // Stack(
            //   fit: StackFit.loose,
            //   children: [
            //     Positioned(
            //       child: Image.asset('images/image.jpg',height: 500, width: 500,),
            //     ),
            //     Positioned(
            //       left: 50,
            //         top: 20,
            //         child: Opacity(
            //           opacity: controller.value ,
            //           child: Text(
            //       'First',
            //       style: TextStyle(fontSize: 100, color: Colors.cyan),
            //     ),
            //         )),
            //     Positioned(
            //         left: 55,
            //         top: 50,
            //         child: Text(
            //       'third',
            //       style: TextStyle(fontSize: 50, color: Colors.white),
            //     )),
            //   ],
            // ),
            // Container(
            //   height: 20,
            //   width: 20,
            //   color: Colors.red,
            // ),
            // Container(
            //   height: 20,
            //   width: 20,
            //   color: Colors.red,
            // ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              AppBar(
                title: Text('Settings'),
                backgroundColor: Colors.purple.shade900,
              ),
              ListTile(
                title: Text(
                  'Exit',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                onTap: () async {
                  // Navigator.pop(context);
                  final firestoreDocument = await _firestoreVar
                      .collection('timeRange')
                      .doc(uid)
                      .get();
                  int to = firestoreDocument.get('to');
                  int from = firestoreDocument.get('from');
                  print(
                      '-----------------------------------------------------');
                  print('$to     $from');
                  print(
                      '-----------------------------------------------------');
                  final now = new DateTime.now();

                  if (now.hour > to) {
                    print(
                        '-----------------------------------------------------');
                    print(now.hour - to);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CostPage(
                          to: now.hour,
                          from: to,
                          extra: true,
                        );
                      },
                    ));
                    print(
                        '-----------------------------------------------------');
                  } else {
                    _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ));
                    //make a exi confermation
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


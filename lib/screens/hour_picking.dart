import 'package:barking/screens/parking_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/data.dart';

class HourPicking extends StatefulWidget {
  HourPicking({this.tab});
  final int tab;
  @override
  _HourPickingState createState() => _HourPickingState();
}

class _HourPickingState extends State<HourPicking> {
  int from = 1;
  int to = 1;
  final now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Booking',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Builder(builder: (context) {
        return SafeArea(
          //: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      'From :  $from',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      activeColor: Color(0xffE71657),
                      inactiveColor: Colors.pink.shade200,
                      min: 1,
                      max: 24,
                      value: from.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          from = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'To :      $to ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      activeColor: Color(0xffE71657),
                      inactiveColor: Colors.pink.shade200,
                      min: 1,
                      max: 24,
                      value: to.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          to = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text('Park Now!'),
                  onPressed: () {
                    if ((from >= now.hour) && (from < to)) {
                      //Provider.of<Data>(context).changeAvailability(widget.tab);

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ParkingPage(
                            from: from,
                            to: to,
                            tab: widget.tab,
                          );
                        },
                      ));
                      //navigate to layout

                    } else if ((from < now.hour) || (from > to)) {
                      final snackBar = SnackBar(
                          content: Text(
                            'please enter a valid date',
                            style: TextStyle(color: Colors.black54),
                          ),
                          backgroundColor: Colors.pink.shade400,
                          action: SnackBarAction(
                            label: 'got it',
                            textColor: Colors.white,
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ));
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else if (from == to) {
                      final snackBar = SnackBar(
                          content: Text(
                            'dates are equal',
                            style: TextStyle(color: Colors.black54),
                          ),
                          backgroundColor: Colors.pink.shade400,
                          action: SnackBarAction(
                            label: 'got it',
                            textColor: Colors.white,
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

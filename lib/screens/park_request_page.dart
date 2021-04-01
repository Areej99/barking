import 'package:barking/screens/hour_picking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParkRequest extends StatelessWidget {
  ParkRequest({this.parkingPage, this.available});
  final int parkingPage;
  final bool available;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/carV.png',
          height: 300,
          width: 200,
        ),
        SizedBox(
          height: 50,
        ),
        FlatButton(
          child: Text('Park Now!'),
          onPressed: available
              ? () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HourPicking(
                        tab: parkingPage,
                      );
                    },
                  ));
                }
              : () {},
          color: available ? Colors.teal : Colors.teal.shade200,
          textColor: Colors.white,
        )
      ],
    );
  }
}

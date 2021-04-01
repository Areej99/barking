import 'package:flutter/material.dart';

class AppBarTab extends StatelessWidget {
  AppBarTab({this.area,this.availability,this.available});
  final String area;
  final String availability;
  final bool available;
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        children: [
          Text(area),
          Text(
            availability,
            style: TextStyle(
                color: available ? Colors.blue : Colors.red,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

import 'package:barking/screens/cost_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barking/model/data.dart';

class ParkingPage extends StatefulWidget {
  ParkingPage({this.tab, this.from, this.to});
  final int tab;
  final int to;
  final int from;

  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    //animation=CurvedAnimation(parent: controller,curve: Curves.decelerate);
    controller.forward();
    animation = Tween(begin: 0.0, end: 100.0).animate(controller);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 100.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    //(begin: Colors.red, end: Colors.blue).animate(controller);
    // getButtonList();
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Layout',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'images/layout.png',
              height: 550,
              width: 400,
            ),
            (widget.tab == 1) || (widget.tab == 2)
                ? Positioned(
                    height: 150,
                    top: 245,
                    left: 90,
                    child: Opacity(
                      opacity: controller.value,
                      child: Image.asset('images/arrow1.png'),
                    ),
                  )
                : Positioned(
                    height: 70,
                    width: 100,
                    top: 325,
                    left: 140,
                    child: Opacity(
                      opacity: controller.value,
                      child: Image.asset('images/arrow2.png'),
                    ),
                  ),
            (widget.tab == 1) || (widget.tab == 2)
                ? Positioned(
                    top: 245,
                    left: 40,
                    child: Text(
                      '${widget.from} : ${widget.to}',
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                  )
                : Positioned(
                    top: 320,
                    left: 270,
                    child: Text(
                      '${widget.from} : ${widget.to}',
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                  ),
            Positioned(
              top: 470,
              left: 130,
              child: FlatButton(
                child: Text('Go forward!'),
                onPressed: () {
                  Provider.of<Data>(context).changeAvailability(widget.tab);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CostPage(
                        to: widget.to,
                        from: widget.from,
                        extra: false,
                      );
                    },
                  ));
                },
                color: Colors.teal,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

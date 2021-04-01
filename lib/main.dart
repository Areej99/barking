import 'file:///D:/projects/barking/lib/screens/login_page.dart';
import 'package:barking/screens/home_page.dart';
import 'package:barking/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/data.dart';
import 'package:barking/screens/login_page.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

  ChangeNotifierProvider<Data>(
    builder :(BuildContext context) => Data()  ,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(), //LoginScreen()
    ),
  ));
}


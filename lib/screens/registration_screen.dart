import 'package:flutter/material.dart';
import 'package:barking/model/data.dart';
import 'package:barking/components/constants.dart';
import 'package:barking/screens/home_page.dart';
import 'package:barking/widgets/reusable_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:barking/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  Future<bool> checkInternetConnectevity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
  }

  var _formKey = GlobalKey<FormState>();

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                Image.asset(
                  'images/icon.png',
                  width: 200,
                  height: 300,
                ),
                SizedBox(
                  height: 48.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@') ||
                                !value.contains('.')) {
                              return 'please enter a proper email format example@ex.ex';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
//Do something with the user input.
                          },
                          decoration: kInputDecoration.copyWith(
                              hintText: 'Enter your Email')),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                          // ignore: missing_return
                          obscureText: true, //for password
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value;
//Do something with the user input.
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'password must be more than 8 characters';
                            } //-----------------------------------------------------------------
                            else {
                              bool hasUpperCase = false;

                              for (int i = 0; i < value.length; i++) {
                                if (value[i].toUpperCase() == value[i]) {
                                  hasUpperCase = true;
                                  break;
                                }
                              }

                              return !hasUpperCase
                                  ? 'password must have at least one upper cas character'
                                  : null;
                            }
                          },
                          decoration: kInputDecoration.copyWith(
                              hintText: 'Enter your password')),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                ButtonWidget(
                  onPressed: () async {
                    bool result = await checkInternetConnectevity();
                    if (!result) {
                      final snackBar = SnackBar(
                          content: Text(
                            'you don\'t have an internet connection',
                            style: TextStyle(color: Colors.black54),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                          action: SnackBarAction(
                            label: 'got it',
                            textColor: Colors.white,
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ));
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else {

                      if (_formKey.currentState.validate()) {

                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          print('------------------------');
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                          print(
                              '$email -------------------------------------------------------------------------------------------------');
                            //final uid = newUser.user.uid;
                            //Provider.of<Data>(context).setUid(uid);
                            //SharedPreferences sharedPreferences =
                                //await SharedPreferences.getInstance();
                            //sharedPreferences.setString('email', email);

                            ////////add a new time document with the same userId
                            //---------------------------------------------------------------------------------------------------------------
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MyHomePage();
                              },
                            ));

                          setState(() {
                            showSpinner = false;
                          });
//Implement registration functionality.
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          if (e.toString().contains('already in use')) {
                            final snackBar = SnackBar(
                                content: Text(
                                  'this email already exists , try another email',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                                action: SnackBarAction(
                                  label: 'got it',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Scaffold.of(context).hideCurrentSnackBar();
                                  },
                                ));

                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                      }
                    }
                  },
                  myColor: Colors.teal,
                  myText: 'Register',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'already have an account ? ',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: Text(' log in here ',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

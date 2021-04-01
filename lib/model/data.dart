import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  String uid ;
  String availability1 = 'Available';
  String availability2 = 'Available';
  String availability3 = 'Available';
  String availability4 = 'Available';


  bool available1 = true;
  bool available2 = true;
  bool available3 = true;
  bool available4 = true;


  void changeAvailability(int tab) {
    switch (tab) {
      case 1:
        availability1 = 'Complete';
        available1=false;
        availability2 = 'Available';
        available2=true;
        availability3 = 'Available';
        available3=true;
        availability4 = 'Available';
        available4=true;
        break;
      case 2:
         availability2 = 'Complete';
         available2=false;
         availability1 = 'Available';
         available1=true;
         availability3 = 'Available';
         available3=true;
         availability4 = 'Available';
         available4=true;
        break;
      case 3:
         availability3 = 'Complete';
         available3=false;
         availability2 = 'Available';
         available2=true;
         availability1 = 'Available';
         available1=true;
         availability4 = 'Available';
         available4=true;
        break;
      case 4:
         availability4 = 'Complete';
         available4=false;
         availability2 = 'Available';
         available2=true;
         availability3 = 'Available';
         available3=true;
         availability1 = 'Available';
         available1 =true;
        break;
    }
    notifyListeners();
  }

void setUid(String userId){
    uid=  userId;
    notifyListeners();


}
}

import 'package:ecom_admin/db/db_helper.dart';
import 'package:ecom_admin/models/app_user.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier{
  List <AppUser> userList = [];

  getAllUsers(){
    DbHelper.getAllUsers().listen((snapshot) {
      userList = List.generate(snapshot.docs.length, (index) =>
          AppUser.fromJson(snapshot.docs[index].data()
          ));
      notifyListeners();
    });
  }
}
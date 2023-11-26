import 'package:ecom_admin/db/db_helper.dart';
import 'package:ecom_admin/models/app_user.dart';
import 'package:flutter/foundation.dart';

import '../models/user_expension_item.dart';

class UserProvider extends ChangeNotifier {
  List <AppUser> userList = [];

  getAllUsers() {
    DbHelper.getAllUsers().listen((snapshot) {
      userList = List.generate(snapshot.docs.length, (index) =>
          AppUser.fromJson(snapshot.docs[index].data()
          ));
      notifyListeners();
    });
  }

  List<AppUserExpensionItem> getAppUserExpensionItemList() {
    List<AppUserExpensionItem> items = [];

    for (final user in userList) {
      final header = AppUserExpensionHeader(email: user.email, timestamp: user.userCreationTime);
      final body = AppUserExpensionBody(
          displayName: user.displayName,
          addressModel: user.userAddress,
          phoneNumber: user.phoneNumber
      );
      final expensionItem = AppUserExpensionItem(header: header, body: body);
      items.add(expensionItem);
    }
    return items;
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin/models/address_model.dart';

class AppUserExpensionItem{
  AppUserExpensionHeader header;
  AppUserExpensionBody body;
  bool isExpanded;

  AppUserExpensionItem({
    required this.header,
    required this.body,
    this.isExpanded = false,

  });
}

class AppUserExpensionHeader{
  String email;
  Timestamp timestamp;

  AppUserExpensionHeader({
    required this.email,
    required this.timestamp,
  });
}

class AppUserExpensionBody{
  AddressModel? addressModel;
  String? displayName;
  String? phoneNumber;

  AppUserExpensionBody({
    this.addressModel,
    this.displayName,
    this.phoneNumber
  });
}
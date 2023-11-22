import 'package:ecom_admin/models/order_model.dart';
import 'package:ecom_admin/utils/constants.dart';
import 'package:flutter/foundation.dart';
import '../db/db_helper.dart';

class OrderProvider extends ChangeNotifier{

  List <OrderModel> orderList = [];

  OrderModel getOrderById(String oid) => orderList.firstWhere((element) => element.orderId == oid);

   getAllOrders(){
    DbHelper.getAllOrders().listen((snapshot) {
      orderList = List.generate(snapshot.docs.length,(index) =>
      OrderModel.fromJson(snapshot.docs[index].data()
      ));
      notifyListeners();
    });
  }


 Future<void> updateOrderStatus (String oid, String value){
     return DbHelper.updateOrderStatus(oid, value);
  }
}
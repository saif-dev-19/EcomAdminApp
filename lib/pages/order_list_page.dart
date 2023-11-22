import 'package:ecom_admin/pages/order_detials_page.dart';
import 'package:ecom_admin/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatelessWidget {

  static const String routeName = "/orderlist";
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order List"),),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.orderList.length,
          itemBuilder: (context, index) {
            final order = provider.orderList[index];
            return ListTile(
              onTap: () => Navigator.pushNamed(context, OrderDetialsPage.routeName, arguments: order.orderId),
              title: Text(order.orderId),
              subtitle: Text(order.orderStatus),
              trailing: Text(order.totalAmount.toString()),
            );
          },
        ),
      )
    );
  }
}



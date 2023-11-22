import 'package:ecom_admin/customwidgets/radio_group.dart';
import 'package:ecom_admin/models/order_model.dart';
import 'package:ecom_admin/providers/order_provider.dart';
import 'package:ecom_admin/utils/constants.dart';
import 'package:ecom_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetialsPage extends StatefulWidget {
  static const String routeName = "/orderdetials";

  const OrderDetialsPage({super.key});

  @override
  State<OrderDetialsPage> createState() => _OrderDetialsPageState();
}

class _OrderDetialsPageState extends State<OrderDetialsPage> {
  late OrderModel order;
  late String groupValue;
  @override
  void didChangeDependencies() {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    order = Provider.of<OrderProvider>(context).getOrderById(orderId);
    groupValue = order.orderStatus;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detials"),
      ),
      body: ListView(
        children: [
          headerSection(title: "Product Info"),
          productSection(order),
          headerSection(title: "Customer Info"),
          customerInfo(order),
          headerSection(title: "Order Status"),
          orderStatusSection(),
        ],
      ),
    );
  }

  ListTile orderStatusSection() {
    return ListTile(
          title: Text(order.orderStatus),
          trailing:order.orderStatus == orderStatus.pending || order.orderStatus == orderStatus.processing ? IconButton(
            onPressed: (){_shorOrderStatusDialog(order);},
            icon: Icon(Icons.edit),) : null,
        );
  }

  Padding customerInfo(OrderModel order) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.appUser.displayName ?? order.appUser.email),
              Text(order.appUser.phoneNumber ?? "Phone not found"),
              Text("${order.appUser.userAddress!.city},${order.appUser.userAddress!.streetAddress},${order.appUser.userAddress!.zipCode}"),
            ],
          ),
        );
  }

  Column productSection(OrderModel order) {
    return Column(
          children: order.orderDetails
              .map((e) => Card(
                    child: ListTile(
                      title: Text(e.productName),
                      subtitle: Text(e.quantity.toString()),
                      trailing: Text(e.price.toString()),
                    ),
                  ))
              .toList(),
        );
  }

  Padding headerSection({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, color: Colors.grey),
      ),
    );
  }

  void _shorOrderStatusDialog(OrderModel order) {
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: const Text("Change Order Status"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder:(context, setBuildState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup(
                  text: orderStatus.pending,
                  groupValue: groupValue,
                  value: orderStatus.pending,
                  onChange: (value){
                      setBuildState(() {
                        groupValue = value;
                      });
                  }
              ),
              RadioGroup(
                  text: orderStatus.processing,
                  groupValue: groupValue,
                  value: orderStatus.processing,
                  onChange: (value){
                    setBuildState(() {
                      groupValue = value;
                    });
                  }
              ),
              RadioGroup(
                  text: orderStatus.delivered,
                  groupValue: groupValue,
                  value: orderStatus.delivered,
                  onChange: (value){
                    setBuildState(() {
                      groupValue = value;
                    });
                  }
              ),
              RadioGroup(
                  text: orderStatus.cancelled,
                  groupValue: groupValue,
                  value: orderStatus.cancelled,
                  onChange: (value){
                    setBuildState(() {
                      groupValue = value;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("CANCEL"),
        ),
        TextButton(
            onPressed: ()async{

              await Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(order.orderId, groupValue);
              Navigator.pop(context);
              showMsg(context, "Order Status Updated");
            },
            child: const Text("UPDATE"),
        ),

      ],
    ));
  }
}

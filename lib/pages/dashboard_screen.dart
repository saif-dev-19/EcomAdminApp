import 'package:ecom_admin/auth/auth_service.dart';
import 'package:ecom_admin/customwidgets/dashboard_item_view.dart';
import 'package:ecom_admin/models/dashboard_item.dart';
import 'package:ecom_admin/pages/launcher_screen.dart';
import 'package:ecom_admin/providers/order_provider.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = "/dashboard";

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders();
    Provider.of<UserProvider>(context, listen: false).getAllUsers();

    return Scaffold(
      appBar: AppBar(
        title:const Text("Dashboard"),
      actions: [
        IconButton(
            onPressed: (){
              AuthService.logOut().then((value) => Navigator.pushReplacementNamed(context, LauncherScreen.routeName));
            },
            icon: const Icon(Icons.logout),)
      ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: DashboardItem.dashboardItemList.length,
          itemBuilder: (context, index) {
            final item = DashboardItem.dashboardItemList[index];
            return DashboardItemView(item: item);
          },
      ),
    );
  }
}

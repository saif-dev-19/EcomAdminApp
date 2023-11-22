import 'package:ecom_admin/pages/category_page.dart';
import 'package:ecom_admin/pages/new_product_page.dart';
import 'package:ecom_admin/pages/order_list_page.dart';
import 'package:ecom_admin/pages/user_list_page.dart';
import 'package:ecom_admin/pages/view_product_page.dart';
import 'package:flutter/material.dart';

class DashboardItem {
  final IconData icon;
  final String name;
  final String route;

DashboardItem({
  required this.icon,
  required this.name,
  required this.route
  });

  static List<DashboardItem> dashboardItemList =[
    DashboardItem(icon: Icons.add, name: "Add Product", route: NewProductPage.routeName),
    DashboardItem(icon: Icons.list, name: "View Product", route: ViewProductPage.routeName),
    DashboardItem(icon: Icons.category, name: "Category", route: CategoryPage.routeName),
    DashboardItem(icon: Icons.bookmark_border, name: "Orders", route: OrderListPage.routeName),
    DashboardItem(icon: Icons.supervised_user_circle_rounded, name: "Users", route: UserListPage.routeName),
  ];
}
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = "/categorypage";

  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) =>
          ListView.builder(
            itemCount:provider.categoryList.length ,
            itemBuilder: (context, index){
              final category = provider.categoryList[index];
              return ListTile(
               title: Text(category.name),

              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSigleTextInputDialog(
              context: context,
              title: "Add Category",
              onSave: (value) {
                EasyLoading.show(status: "Please Wait");
               Provider.of<ProductProvider>(context, listen: false)
                    .addCategory(value)
                    .then((value) => {
                      EasyLoading.dismiss(),
                  showMsg(context, "Category Saved")
                })
                    .catchError((error) {
                      EasyLoading.dismiss();
                      showMsg(context, "Could not Save");
                });
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

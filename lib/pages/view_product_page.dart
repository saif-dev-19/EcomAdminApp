import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/pages/product_detials_page.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widget_functions.dart';

class ViewProductPage extends StatelessWidget {
  static const String routeName = "/viewproduct";
  const ViewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Product")),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {

            final product = provider.productList[index];

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 20,),
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white, size: 30,),
              ),
              confirmDismiss: (direction) {
                return showDialog(context: context, builder: (context) => AlertDialog(
                  title: const Text('Delete Product'),
                  content: Text('Are you sure to delete product ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('NO'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('YES'),
                    ),
                  ],
                ));
              },
              onDismissed: (direction)async{
                final deleteProduct = await provider.deleteProductField(product.id!);
                showMsg(context, 'Deleted');
            },
              child: ListTile(
                onTap: () => Navigator.pushNamed(context,
                    ProductDetialsPage.routeName, arguments: product.id),

                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.easeInOut,
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) => const Center(child:CircularProgressIndicator(),),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error),),
                  ),
                ),
                title: Text(product.category.name),
                subtitle: Text("Stock: ${product.stock}"),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     const Icon(Icons.star, color: Colors.amber,),
                     Text(product.avgRating.toStringAsFixed(1),style: TextStyle (fontSize: 16),),
                  ],
                ),
              ),
            );
          },
        ) ,
      ),
    );
  }
}

import 'package:ecom_admin/providers/user_provider.dart';
import 'package:ecom_admin/utils/helper_functions.dart';
import 'package:ecom_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/user_expension_item.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = "/userlist";
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<AppUserExpensionItem> itemList = [];
  @override
  void didChangeDependencies() {
    itemList = Provider.of<UserProvider>(context, listen: false).getAppUserExpensionItemList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User List"),),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  itemList[index].isExpanded = isExpanded;
                });
              },
              children: itemList.map((item) => ExpansionPanel(
                headerBuilder: (context, isExpanded) => ListTile(
                  title: Text(item.header.email),
                  subtitle: Text("Subscribed on :${getFormattedDate(item.header.timestamp.toDate())}"),
                ),
                body: Column(
                  children: [
                    Text(item.body.displayName ?? "Name Not Found"),
                    Text(item.body.addressModel?.streetAddress ?? "Address Not Found"),
                    Text(item.body.phoneNumber ?? "Phone number not founnd"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        IconButton(
                            onPressed: (){
                              _userAction("tel:${item.body.phoneNumber}");
                            },
                            icon: Icon(Icons.call)
                        ),
                        IconButton(
                            onPressed: (){
                              _userAction("sms:${item.body.phoneNumber}");
                            },
                            icon: Icon(Icons.sms)
                        ),
                        IconButton(
                            onPressed: (){
                              _userAction("mailto:${item.header.email}");
                            },
                            icon: Icon(Icons.email)
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.map)
                        ),
                      ]
                    )
                  ],
                ),
                isExpanded: item.isExpanded,
              )).toList(),
            ),
          );
        }
      ),
    );
  }

  ListView buildListView(UserProvider provider) {
    return ListView.builder(
        itemCount: provider.userList.length,
        itemBuilder: (context, index) {
          final user = provider.userList[index];
          return ListTile(
            title: Text(user.displayName ?? user.email),
            subtitle: Text("User Created on:${getFormattedDate(user.userCreationTime.toDate())}"),
            trailing: IconButton(
              onPressed: ()async{
                final url = "mailto:${user.email}";
                if(await canLaunchUrlString(url)){
                  await launchUrlString(url);
                }else{
                  showMsg(context, "No apps found to perfrom this action");
                }
              },
              icon: const Icon(Icons.mail),
            ),
          );
        },
      );
  }

  void _userAction(String url)async {
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, "No apps found to perfrom this action");
    }
  }
}



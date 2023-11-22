import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom_admin/models/category_model.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = "/newproduct";
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  String? localImagePath;
  CategoryModel? categoryModel;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    _checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Product"),
      actions: [
        IconButton(
            onPressed: isConnected ? _saveProduct : null,
            icon: const Icon(Icons.save))
      ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            if(!isConnected)_buildConnectivityAlertSection(),
            _buildImageSection(),
            _buildCategorySection(),
            _buildTextFieldSection(),
          ],
        ),
      ),
    );
  }


 Widget _buildImageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            localImagePath == null ? const Icon(Icons.card_giftcard, size: 100,) :
                Image.file(File(localImagePath!), width: 100, height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: (){
                      _getImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Capture"),
                ),

                TextButton.icon(
                  onPressed: (){
                    _getImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
 }


  void _getImage(ImageSource source) async{
    final file = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if(file != null) {
      setState(() {
        localImagePath = file.path;
      });
    }
  }

 Widget _buildCategorySection() {
    return Card(
      child:Consumer<ProductProvider>(
        builder: (context, provider, child) =>
         DropdownButtonFormField<CategoryModel>(
          value: categoryModel,
          hint: const Text("Select Category"),
          isExpanded: true,
          items: provider.categoryList.map((category) => DropdownMenuItem<CategoryModel>(
              value: category,
              child: Text(category.name))).toList(),
          onChanged: (value){
            setState(() {
              categoryModel = value;
            });
          },
           validator: (value){
             if(value == null){
               return "This field must not be empty";
             }
             return null;
           },
        ),
      ) ,
    );
 }


 @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

 Widget _buildTextFieldSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              labelText: "Product Name"
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return "This field must not be empty";
              }
              return null;
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
                filled: true,
                labelText: "Product Price"
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return "This field must not be empty";
              }
              return null;
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
                filled: true,
                labelText: "Product Description(Optional)"
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _stockController,
            decoration: InputDecoration(
                filled: true,
                labelText: "Product Stock"
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return "This field must not be empty";
              }
              return null;
            },
          ),
        ),
      ],
    );
 }

  void _saveProduct()async {
    if(localImagePath == null){
      showMsg(context, "Please Select a Product Image");
      return;
    }
    if(_formKey.currentState!.validate()){
      final imageUrl = await Provider.of<ProductProvider>(context, listen: false)
      .uploadImage(localImagePath!);
      final productModel = ProductModel(
          name: _nameController.text,
          category: categoryModel!,
          price: num.parse(_priceController.text),
          stock: num.parse(_stockController.text),
          imageUrl: imageUrl,
      );
      EasyLoading.show(status:"Please Wait");
      Provider.of<ProductProvider>(context, listen: false)
      .addProduct(productModel)
      .then((value){
        EasyLoading.dismiss();
        showMsg(context, "Saved");
        _resetFields();
      })
      .catchError((error){
        EasyLoading.dismiss();
        showMsg(context, "Could not save");
      });

    }
  }

  void _resetFields() {
    setState(() {
      localImagePath = null;
      categoryModel = null;
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _stockController.clear();

    });
  }

  Widget _buildConnectivityAlertSection() {
    return Container(
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      color: Colors.red,
      child: const Text("No Internet Connection."),
    );
  }

  void _checkConnection()async {
    final result = await Connectivity().checkConnectivity();
    checkConnectionResult(result);

    subscription = Connectivity().onConnectivityChanged.listen((result) {
      checkConnectionResult(result);
    });
  }




  void checkConnectionResult(ConnectivityResult result) {
     if(result != ConnectivityResult.mobile || result != ConnectivityResult.wifi){
      setState(() {
        isConnected = true;
      });
    } else{
      setState(() {
        isConnected = false;
      });
    }
  }
}



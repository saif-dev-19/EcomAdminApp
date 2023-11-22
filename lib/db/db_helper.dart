import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin/models/category_model.dart';
import 'package:ecom_admin/models/order_model.dart';
import 'package:ecom_admin/models/product_model.dart';

class DbHelper{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionAdmin = "Admins";
  static const String collectionCategory = "Categories";
  static const String collectionProduct = "Products";
  static const String collectionOrder = "Order";
  static const String collectionUsers = "Users";
  static const String collectionCart = "MyCart";
  static const String collectionRating = "Ratings";

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  //AddCategory
  static Future<void> addCategory(CategoryModel category)  {
    final doc =  _db.collection(collectionCategory).doc();
    category.id =doc.id;
    return doc.set(category.toJson());
  }

  static Future<void> addProduct(ProductModel product) {
    final doc = _db.collection(collectionProduct).doc();
    product.id =doc.id;
    return doc.set(product.toJson());
  }
  
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() => 
      _db.collection(collectionCategory)
          .orderBy("name", descending: false)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProduct() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
      _db.collection(collectionOrder).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() =>
      _db.collection(collectionUsers).snapshots();

 static Future<void> updateProductField(String id, Map<String, dynamic> map){
    return _db.collection(collectionProduct)
        .doc(id)
        .update(map);
  }
  static Future<void> deleteProductField(String id){
    return _db.collection(collectionProduct)
        .doc(id)
        .delete();
  }

  static Future<void> updateOrderStatus(String oid, String value){
    return _db.collection(collectionOrder)
        .doc(oid)
        .update({"orderStatus": value});
  }
}
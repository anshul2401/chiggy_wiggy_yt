import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductApi {
  CollectionReference users = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel productModel) {
    return users.add(productModel.toJson()).then((value) {
      throw value;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, ProductModel productModel) {
    return users
        .doc(id)
        .update(productModel.toJson())
        .then((value) => print("Product Updated"))
        .catchError((error) {
      throw error;
    });
  }
}

import 'dart:convert';

import 'package:chiggy_wiggy/models/product_model.dart';

class CartModel {
  String? id;
  ProductModel? productModel;
  int? qty;
  CartModel({
    required this.id,
    required this.productModel,
    required this.qty,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        productModel: ProductModel.fromJson(json['productModel']),
        qty: json['qty']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productModel': productModel!.toJson(),
      'qty': qty,
    };
  }
}

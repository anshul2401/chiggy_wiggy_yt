import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderApi {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(OrderModel orderModel) {
    return orders.add(orderModel.toJson()).then((value) {}).catchError((error) {
      throw error;
    });
  }

  Future<void> updateOrder(String id, String status) {
    return orders
        .doc(id)
        .update({'status': status})
        .then((value) => print("Order Updated"))
        .catchError((error) {
          throw error;
        });
  }
}

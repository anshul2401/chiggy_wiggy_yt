import 'dart:convert';

import 'package:chiggy_wiggy/models/delivery_charges_model.dart';
import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryChargeApi {
  CollectionReference deliveryCharge =
      FirebaseFirestore.instance.collection('delivery_charges');

  Future<void> addDeliveryCharges(DeliveryChargeModel deliveryChargeModel) {
    return deliveryCharge.add(deliveryChargeModel.toJson()).then((value) {
      throw value;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateDeliveryCharge(
      String id, DeliveryChargeModel deliveryChargeModel) {
    return deliveryCharge
        .doc(id)
        .update(deliveryChargeModel.toJson())
        .then((value) => print("Delivery Charges Updated"))
        .catchError((error) {
      throw error;
    });
  }

  Future<List<DeliveryChargeModel>> getArea() async {
    List<DeliveryChargeModel> deliveryCharges = [];
    await deliveryCharge.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String d = json.encode(doc.data());

        DeliveryChargeModel dm = DeliveryChargeModel.fromJson(jsonDecode(d));
        deliveryCharges.add(dm);
      });
    });
    return deliveryCharges;
  }
}

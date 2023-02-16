import 'dart:convert';

import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/models/coupon_model.dart';
import 'package:chiggy_wiggy/models/delivery_charges_model.dart';
import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponApi {
  CollectionReference coupon = FirebaseFirestore.instance.collection('coupons');

  Future<void> addCoupon(CouponModel couponModel) {
    return coupon.add(couponModel.toJson()).then((value) {
      throw value;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateCoupon(String id, CouponModel couponModel) {
    return coupon
        .doc(id)
        .update(couponModel.toJson())
        .then((value) => print("Coupon Updated"))
        .catchError((error) {
      throw error;
    });
  }

  Future<List<CouponModel>> getCoupons() async {
    List<CouponModel> coupons = [];
    await coupon.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String d = json.encode(doc.data());

        CouponModel dm = CouponModel.fromJson(jsonDecode(d));
        coupons.add(dm);
      });
    });
    return coupons;
  }

  Future<void> deleteCoupon(String id) {
    return coupon
        .doc(id)
        .delete()
        .then((value) => print("Coupon Deleted"))
        .catchError((error) {
      throw error;
    });
  }

  Future getCopon(String name) async {
    CouponModel? couponModel;
    await coupon.where('name', isEqualTo: name).get().then((QuerySnapshot q) {
      if (q.docs.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> data =
            q.docs.first.data()! as Map<String, dynamic>;
        CouponModel couponModell = CouponModel.fromJson(data);

        couponModel = couponModell;
      }
    });
    return couponModel;
  }

  Future getAndUpdateCopon(String name) async {
    await coupon.where('name', isEqualTo: name).get().then((QuerySnapshot q) {
      if (q.docs.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> data =
            q.docs.first.data()! as Map<String, dynamic>;
        CouponModel couponModell = CouponModel.fromJson(data);
        List usedBy = couponModell.usedById;
        usedBy.add(currentUser!.id);
        coupon.doc(q.docs.first.id).update({'usedById': usedBy});
      }
    });
  }
}

import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class BannerAPi {
  CollectionReference banner = FirebaseFirestore.instance.collection('banner');

  Future<void> addBanner(String imgurl) {
    return banner
        .doc('banner')
        .set({'imgUrl': imgurl})
        .then((value) {})
        .catchError((error) {
          throw error;
        });
  }

  Future<void> updateBanner(String imgUrl) {
    return banner
        .doc('banner')
        .update({'imgUrl': imgUrl})
        .then((value) => print("Banner Updated"))
        .catchError((error) {
          throw error;
        });
  }

  Future<String> getBanner() {
    return banner.doc('banner').get().then((value) {
      print(value);
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      return data.entries.first.value;
      print(data.entries.first.value);
      // return value;
    });
  }
}

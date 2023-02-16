import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageUploadApi {
  static UploadTask? uploadImage(String destination, File file) {
    try {
      final reference = FirebaseStorage.instance.ref(destination);
      return reference.putFile(file);
    } on FirebaseException catch (error) {
      throw error;
    }
  }
}

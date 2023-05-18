import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final fireStorage = FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await fireStorage.ref(fileName).putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<ListResult> listFiles() async {
    ListResult listResult = await fireStorage.ref('products/images').listAll();
    return listResult;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await fireStorage.ref(imageName).getDownloadURL();
    return downloadURL;
  }
}
